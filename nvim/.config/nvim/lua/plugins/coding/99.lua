return {
	"ThePrimeagen/99",
	dependencies = {
		{ "saghen/blink.compat", version = "2.*" },
	},
	config = function()
		local _99 = require("99")
		local picker_utils = require("99.extensions.pickers")
		local tmp_dir = vim.fn.stdpath("cache") .. "/99"

		local function select_current(items, current, prompt, on_choice)
			local current_index = math.max(vim.fn.index(items, current) + 1, 1)

			Snacks.picker.select(items, {
				prompt = prompt .. " (current: " .. current .. ")",
				snacks = {
					on_show = function(picker)
						picker.list:view(current_index)
					end,
				},
			}, function(choice)
				if choice then
					on_choice(choice)
				end
			end)
		end

		-- 99 does not include a Codex provider yet, but its provider API supports
		-- using Codex's non-interactive mode as a small local adapter.
		local CodexProvider = setmetatable({}, { __index = _99.Providers.BaseProvider })

		function CodexProvider._build_command(_, query, context)
			return {
				"codex",
				"exec",
				"--ephemeral",
				"--skip-git-repo-check",
				"--sandbox",
				"workspace-write",
				"--color",
				"never",
				"--add-dir",
				tmp_dir,
				"--model",
				context.model,
				query,
			}
		end

		function CodexProvider._get_provider_name()
			return "CodexProvider"
		end

		function CodexProvider._get_default_model()
			return "gpt-5.6-sol"
		end

		function CodexProvider.fetch_models(callback)
			callback({ CodexProvider._get_default_model() }, nil)
		end

		_99.Providers.CodexProvider = CodexProvider

		local cwd = vim.uv.cwd()
		local basename = vim.fs.basename(cwd)

		_99.setup({
			provider = CodexProvider,
			logger = {
				level = _99.DEBUG,
				path = "/tmp/" .. basename .. ".99.debug",
				print_on_error = true,
			},
			tmp_dir = tmp_dir,
			completion = {
				source = "blink",
			},
			md_files = {
				"AGENTS.md",
				"AGENT.md",
			},
		})

		vim.keymap.set("v", "<leader>9v", function()
			_99.visual()
		end, { desc = "99: Edit selection" })

		vim.keymap.set("n", "<leader>9x", function()
			_99.stop_all_requests()
		end, { desc = "99: Stop requests" })

		vim.keymap.set("n", "<leader>9s", function()
			_99.search()
		end, { desc = "99: Search project" })

		vim.keymap.set("n", "<leader>9b", function()
			_99.vibe()
		end, { desc = "99: Vibe project" })

		vim.keymap.set("n", "<leader>9m", function()
			picker_utils.get_models(nil, function(models, current)
				select_current(models, current, "99: Select Model", picker_utils.on_model_selected)
			end)
		end, { desc = "99: Select model" })

		vim.keymap.set("n", "<leader>9p", function()
			local info = picker_utils.get_providers()
			select_current(info.names, info.current, "99: Select Provider", function(name)
				picker_utils.on_provider_selected(name, info.lookup)
			end)
		end, { desc = "99: Select provider" })
	end,
}
