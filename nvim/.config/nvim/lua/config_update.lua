local M = {}

local title = "Dotfiles updater"
local busy = false

local function notify(message, level)
	vim.notify(message, level, { title = title })
end

local function result_text(result)
	local text = vim.trim(result.stderr or "")
	return text ~= "" and text or vim.trim(result.stdout or "")
end

local function git(repo, args, callback)
	local command = { "git" }
	vim.list_extend(command, args)

	local function on_exit(result)
		result.stdout = vim.trim(result.stdout or "")
		result.stderr = vim.trim(result.stderr or "")
		vim.schedule(function()
			callback(result)
		end)
	end

	local ok, error = pcall(vim.system, command, {
		cwd = repo,
		env = { GIT_TERMINAL_PROMPT = "0" },
		text = true,
		timeout = 60000,
	}, on_exit)

	if not ok then
		on_exit({ code = 127, stderr = tostring(error), stdout = "" })
	end
end

function M._parse_counts(output)
	local ahead, behind = output:match("^(%d+)%s+(%d+)%s*$")
	return tonumber(ahead), tonumber(behind)
end

local function restore_stash(repo, stash, callback)
	git(repo, { "rev-parse", "--verify", "refs/stash" }, function(current)
		if current.code ~= 0 or current.stdout ~= stash then
			callback(false, "The stash stack changed; your changes remain in stash " .. stash:sub(1, 10) .. ".")
			return
		end

		git(repo, { "stash", "pop", "--index", "stash@{0}" }, function(result)
			if result.code == 0 then
				callback(true)
			else
				callback(false, "Your changes remain in the stash.\n" .. result_text(result))
			end
		end)
	end)
end

local function pull(repo, stash, finish)
	git(repo, { "pull", "--ff-only" }, function(result)
		local updated = result.code == 0

		if not stash then
			notify(
				updated and "Dotfiles updated. Restart Neovim to load the new configuration."
					or "Dotfiles update failed.\n" .. result_text(result),
				updated and vim.log.levels.INFO or vim.log.levels.ERROR
			)
			finish()
			return
		end

		restore_stash(repo, stash, function(restored, restore_error)
			if updated and restored then
				notify("Dotfiles updated and local changes restored. Restart Neovim.", vim.log.levels.INFO)
			elseif updated then
				notify("Dotfiles updated, but local changes could not be restored.\n" .. restore_error, vim.log.levels.ERROR)
			elseif restored then
				notify("Dotfiles update failed; local changes were restored.\n" .. result_text(result), vim.log.levels.ERROR)
			else
				notify(
					"Dotfiles update failed, and local changes could not be restored.\n"
						.. result_text(result)
						.. "\n"
						.. restore_error,
					vim.log.levels.ERROR
				)
			end
			finish()
		end)
	end)
end

local function update(repo, finish)
	git(repo, { "status", "--porcelain=v1", "--untracked-files=normal" }, function(status)
		if status.code ~= 0 then
			notify("Could not inspect local changes.\n" .. result_text(status), vim.log.levels.ERROR)
			finish()
			return
		end

		if status.stdout == "" then
			pull(repo, nil, finish)
			return
		end

		git(repo, { "rev-parse", "--verify", "refs/stash" }, function(previous)
			local previous_stash = previous.code == 0 and previous.stdout or ""
			local message = "Neovim dotfiles update " .. os.date("!%Y-%m-%dT%H:%M:%SZ")

			git(repo, { "stash", "push", "--include-untracked", "--message", message }, function(stashed)
				if stashed.code ~= 0 then
					notify("Could not stash local changes; update cancelled.\n" .. result_text(stashed), vim.log.levels.ERROR)
					finish()
					return
				end

				git(repo, { "rev-parse", "--verify", "refs/stash" }, function(current)
					if current.code ~= 0 or current.stdout == previous_stash then
						notify("Git did not create a stash; update cancelled.", vim.log.levels.ERROR)
						finish()
						return
					end
					pull(repo, current.stdout, finish)
				end)
			end)
		end)
	end)
end

function M.check(options)
	options = options or {}
	if busy then
		if options.verbose then
			notify("An update check is already running.", vim.log.levels.INFO)
		end
		return
	end
	busy = true

	local function finish()
		busy = false
	end

	local function fail(message, result)
		finish()
		if options.verbose then
			notify(message .. (result and ("\n" .. result_text(result)) or ""), vim.log.levels.ERROR)
		end
	end

	local config = vim.uv.fs_realpath(vim.fn.stdpath("config"))
	if not config then
		fail("Could not resolve the Neovim configuration path.")
		return
	end

	git(config, { "rev-parse", "--show-toplevel" }, function(root)
		if root.code ~= 0 then
			fail("The Neovim configuration is not in a Git repository.", root)
			return
		end
		local repo = root.stdout

		git(repo, { "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}" }, function(upstream)
			if upstream.code ~= 0 then
				fail("The current dotfiles branch has no upstream.", upstream)
				return
			end

			git(repo, { "fetch", "--quiet" }, function(fetched)
				if fetched.code ~= 0 then
					fail("Could not fetch dotfiles updates.", fetched)
					return
				end

				git(repo, { "rev-list", "--left-right", "--count", "HEAD...@{upstream}" }, function(counted)
					if counted.code ~= 0 then
						fail("Could not compare the local and remote branches.", counted)
						return
					end

					local ahead, behind = M._parse_counts(counted.stdout)
					if not ahead then
						fail("Git returned an unexpected commit count.", counted)
					elseif behind == 0 then
						finish()
						if options.verbose then
							notify(ahead == 0 and "Dotfiles are up to date." or ("Dotfiles are %d commit(s) ahead."):format(ahead), vim.log.levels.INFO)
						end
					elseif ahead > 0 then
						finish()
						notify("Dotfiles have diverged from " .. upstream.stdout .. "; update them manually.", vim.log.levels.WARN)
					else
						notify(("%d new dotfiles commit(s) are available."):format(behind), vim.log.levels.INFO)
						vim.ui.select({ "Update now", "Later" }, {
							prompt = "Update the entire dotfiles repository?",
							kind = "dotfiles_update",
						}, function(choice)
							if choice == "Update now" then
								update(repo, finish)
							else
								finish()
							end
						end)
					end
				end)
			end)
		end)
	end)
end

function M.setup()
	vim.api.nvim_create_user_command("DotfilesUpdateCheck", function()
		M.check({ verbose = true })
	end, { desc = "Check for dotfiles updates" })

	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.defer_fn(function()
				if #vim.api.nvim_list_uis() > 0 then
					M.check()
				end
			end, 1000)
		end,
	})
end

return M
