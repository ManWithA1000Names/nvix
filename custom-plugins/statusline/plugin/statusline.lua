local fn = vim.fn

-- og-bg: #16161E

vim.cmd([[highlight St_Green guifg=#96C077 guibg=#16161E gui=nocombine]])
vim.cmd([[highlight St_NormalMode guifg=#5FACED guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_TerminalMode guifg=#16161E guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_NTerminalMode guifg=#16161E guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_ReplaceMode guifg=#E06C75 guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_VisualMode guifg=#E4C585 guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_SelectMode guifg=#E4C585 guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_InsertMode guifg=#96C077 guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_ConfirmMode guifg=#D699B2 guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight St_CommandMode guifg=#907179 guibg=#363A42 gui=nocombine]])
vim.cmd([[highlight StText guifg=#99ffee guibg=#16161E gui=nocombine]])
vim.cmd([[highlight St_Git guifg=#CB1ED1 guibg=#16161E gui=nocombine]])

vim.cmd([[highlight St_lspWarning guifg=#ECC885 guibg=#16161E gui=nocombine]])
vim.cmd([[highlight St_lspError guifg=#ED7079 guibg=#16161E gui=nocombine]])
vim.cmd([[highlight St_lspInfo guifg=#0FADC9 guibg=#16161E gui=nocombine]])
vim.cmd([[highlight St_lspHints guifg=#1AB798 guibg=#16161E gui=nocombine]])

local modes = {
	["n"] = { "NORMAL", "St_NormalMode" },
	["no"] = { "NORMAL (no)", "St_NormalMode" },
	["nov"] = { "NORMAL (nov)", "St_NormalMode" },
	["noV"] = { "NORMAL (noV)", "St_NormalMode" },
	["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
	["niI"] = { "NORMAL i", "St_NormalMode" },
	["niR"] = { "NORMAL r", "St_NormalMode" },
	["niV"] = { "NORMAL v", "St_NormalMode" },
	["nt"] = { "NTERMINAL", "St_NTerminalMode" },
	["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

	["v"] = { "VISUAL", "St_VisualMode" },
	["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
	["V"] = { "V-LINE", "St_VisualMode" },
	["Vs"] = { "V-LINE", "St_VisualMode" },
	[""] = { "V-BLOCK", "St_VisualMode" },

	["i"] = { "INSERT", "St_InsertMode" },
	["ic"] = { "INSERT (completion)", "St_InsertMode" },
	["ix"] = { "INSERT completion", "St_InsertMode" },

	["t"] = { "TERMINAL", "St_TerminalMode" },

	["R"] = { "REPLACE", "St_ReplaceMode" },
	["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
	["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
	["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
	["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
	["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

	["s"] = { "SELECT", "St_SelectMode" },
	["S"] = { "S-LINE", "St_SelectMode" },
	[""] = { "S-BLOCK", "St_SelectMode" },
	["c"] = { "COMMAND", "St_CommandMode" },
	["cv"] = { "COMMAND", "St_CommandMode" },
	["ce"] = { "COMMAND", "St_CommandMode" },
	["r"] = { "PROMPT", "St_ConfirmMode" },
	["rm"] = { "MORE", "St_ConfirmMode" },
	["r?"] = { "CONFIRM", "St_ConfirmMode" },
	["x"] = { "CONFIRM", "St_ConfirmMode" },
	["!"] = { "SHELL", "St_TerminalMode" },
}

local function mode()
	local m = vim.api.nvim_get_mode().mode
	return "%#" .. modes[m][2] .. "#" .. "  " .. modes[m][1] .. " "
end

local function fileInfo()
	local icon = " 󰈚 "
	local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:t")

	if filename ~= "Empty " then
		local devicons_present, devicons = pcall(require, "nvim-web-devicons")

		if devicons_present then
			-- TODO: get and set the color as well
			local ft_icon = devicons.get_icon(filename)
			icon = (ft_icon ~= nil and " " .. ft_icon) or ""
		end

		filename = " " .. filename .. " "
	end

	return "%#StText# " .. icon .. filename
end

local function git()
	if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
		return ""
	end

	return "%#St_Git#  " .. vim.b.gitsigns_status_dict.head .. "  "
end

local function gitchanges()
	if not vim.b.gitsigns_head or vim.b.gitsigns_git_status or vim.o.columns < 120 then
		return ""
	end

	local git_status = vim.b.gitsigns_status_dict

	local added = (git_status.added and git_status.added ~= 0) and ("%#St_Green#  " .. git_status.added .. " ") or ""
	local changed = (git_status.changed and git_status.changed ~= 0)
			and ("%#St_lspWarning#  " .. git_status.changed .. " ")
		or ""
	local removed = (git_status.removed and git_status.removed ~= 0)
			and ("%#St_lspError#  " .. git_status.removed .. " ")
		or ""

	return (added .. changed .. removed) ~= "" and (added .. changed .. removed .. "%#St_Nothing# | ") or ""
end

-- LSP STUFF
local function LSP_Diagnostics()
	if not rawget(vim, "lsp") then
		return "%#St_lspError# 󰅚 0 %#St_lspWarning# 0"
	end

	local has_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local has_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local has_hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	local has_info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

	local errors = (has_errors and has_errors > 0) and ("%#St_lspError#󰅚 " .. has_errors .. " ")
		or "%#St_Nothing#󰅚 0 "
	local warnings = (has_warnings and has_warnings > 0) and ("%#St_lspWarning# " .. has_warnings .. " ")
		or "%#St_Nothing# 0 "
	local hints = (has_hints and has_hints > 0) and ("%#St_lspHints#󰛩 " .. has_hints .. " ") or ""
	local info = (has_info and has_info > 0) and ("%#St_lspInfo# " .. has_info .. " ") or ""

	return vim.o.columns > 140 and errors .. warnings .. hints .. info or ""
end

local function filetype()
	local ft = vim.bo.filetype == "" and "plain text" or vim.bo.filetype
	return "%#St_Nothing#|  %#StText#" .. ft .. "%#St_Nothing# "
end

local function LSP_status()
	if rawget(vim, "lsp") then
		for _, client in ipairs(vim.lsp.get_active_clients()) do
			if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.name ~= "null-ls" then
				return (vim.o.columns > 100 and "%#St_Green# 󰄭 %#St_Nothing# " .. client.name .. "  ")
					or "%#St_Green# 󰄭 %#St_Nothing# LSP  "
			end
		end
	end

	return ""
end

local function cursor_position()
	return vim.o.columns > 140 and "%#St_Nothing# %P Ln %l, Col %c  " or ""
end

local function file_encoding()
	local encoding = string.upper(vim.bo.fileencoding)
	if encoding == "" then
		return ""
	end
	if encoding == "UTF-8" then
		return "%#St_Nothing#" .. encoding .. "  "
	end
	return "%#St_lspError#" .. encoding .. "  "
end

local function cwd()
	local dir_name = "%#St_lspInfo# 󰉖 " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
	return (vim.o.columns > 85 and dir_name) or ""
end

_G.custom_statusline = function()
	local modules = {
		mode(),
		fileInfo(),
		git(),
		LSP_Diagnostics(),
		"%=",
		"%=",
		gitchanges(),
		cursor_position(),
		file_encoding(),
		filetype(),
		LSP_status(),
		cwd(),
	}

	return table.concat(modules)
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.filetype ~= "NvimTree" then
			vim.cmd([[setlocal statusline=%!v:lua.custom_statusline()]])
		end
	end,
})
