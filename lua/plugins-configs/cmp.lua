local cmp = require("cmp")

local luasnip = require("luasnip")

require("luasnip/loaders/from_vscode").lazy_load()

local kind_icons = {
	Text = " (Text)",
	Method = "m (Method)",
	Function = " (Function)",
	Constructor = " (Constructor)",
	Field = " (Field)",
	Variable = " (Variable)",
	Class = " (Class)",
	Interface = " (Interface)",
	Module = " (Module)",
	Property = " (Property)",
	Unit = " (Unit)",
	Value = " (Value)",
	Enum = " (Enum)",
	Keyword = " (Keyword)",
	Snippet = " (Snippet)",
	Color = " (Color)",
	File = " (File)",
	Reference = " (Reference)",
	Folder = " (Folder)",
	EnumMember = " (Enum)",
	Constant = " (Constant)",
	Struct = " (Struct)",
	Event = " (Event)",
	Operator = " (Operator)",
	TypeParameter = " (TypeParameter)",
}

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { "menu", "abbr", "kind" },
		format = function(entry, vim_item)
			if #vim_item.abbr > 20 then
				vim_item.abbr = string.sub(vim_item.abbr, 1, 19) .. "…"
			end
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.menu = ({
				nvim_lsp = " ",
				luasnip = " ",
				buffer = "",
				path = " ",
				fish = " ",
				nvim_lua = " ",
				nvim_lsp_signature_help = "?",
			})[entry.source.name]
			return vim_item
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-e>"] = cmp.mapping.abort(),
		["<A-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<A-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		[";"] = cmp.mapping.confirm({ select = true }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			elseif cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lua" },
		{ name = "fish" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "buffer" },
	}),
	experimental = {
		ghost_text = true,
	},
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

vim.keymap.set("n", "<Tab>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
		vim.cmd("startinsert")
	end
end, { noremap = true, silent = true })
