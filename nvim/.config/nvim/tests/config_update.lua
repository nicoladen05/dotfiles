vim.opt.runtimepath:prepend(vim.fn.getcwd())

local updater = require("config_update")
local ahead, behind = updater._parse_counts("2\t3\n")
assert(ahead == 2 and behind == 3)
assert(updater._parse_counts("unexpected") == nil)
