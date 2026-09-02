-- Automatic character pairs
return {
	"nvim-mini/mini.pairs",
	version = "0.17.0",
	opts = {
		modes = { insert = true, command = true, terminal = false },
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	},
}
