local configs = require("nvim-treesitter.configs")

local parser_install_path = vim.fn.stdpath("cache") .. "/parsers"
vim.opt.runtimepath:append(parser_install_path)

configs.setup({
	parser_install_dir = parser_install_path,
	ensure_installed = {
		"lua",
		"rust",
		"typescript",
		"javascript",
		"tsx",
		"css",
		"html",
		"go",
		"gomod",
		"bash",
		"fish",
		"julia",
		"json",
		"toml",
		"yaml",
		"python",
		"prisma",
		"c",
		"cpp",
		"nix",
		"haskell",
	},
	sync_install = false,
	highlight = {
		enable = true,
		disable = { "" },
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	autotag = {
		enable = true,
	},
})
