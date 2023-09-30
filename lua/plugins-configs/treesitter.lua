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
		"comment",
		"markdown_inline",
		"regex",
	},
	sync_install = false,
	matchup = {
		enable = false,
	},
	highlight = {
		enable = true,
		disable = function(lang, buf)
			if vim.tbl_contains({ "latex" }, lang) then
				return true
			end

			local status_ok, big_file_detected = pcall(vim.api.nvim_buf_get_var, buf, "bigfile_disable_treesitter")
			return status_ok and big_file_detected
		end,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		config = {
			typescript = "// %s",
			css = "/* %s */",
			scss = "/* %s */",
			html = "<!-- %s -->",
			svelte = "<!-- %s -->",
			vue = "<!-- %s -->",
			lua = "-- %s",
			json = "",
		},
	},
	indent = { enable = true, disable = { "yaml", "python" } },
	autotag = { enable = false },
	textobjects = {
		swap = { enable = false },
		select = { enable = false },
	},
	textsubjects = {
		enable = false,
		keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = 1000,
	},
})
