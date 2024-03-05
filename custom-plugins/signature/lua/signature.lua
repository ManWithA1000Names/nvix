-- stolen from https://www.github.com/NvChad/ui/blob/v2.0/nvchad/signature.lua
local M = {}

function M.signature_window(_, result, ctx, config)
	local bufnr, winner = vim.lsp.handlers.signature_help(_, result, ctx, config)
	local current_cursor_line = vim.api.nvim_win_get_cursor(0)[1]

	if winner and current_cursor_line > 3 then
		vim.api.nvim_win_set_config(winner, {
			anchor = "SW",
			relative = "cursor",
			row = 0,
			col = -1,
		})
	end

	if bufnr and winner then
		return bufnr, winner
	end
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local util = require("vim.lsp.util")
local clients = {}

local function check_trigger_char(line_to_cursor, triggers)
	if not triggers then
		return false
	end

	for _, trigger_char in ipairs(triggers) do
		local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
		local prev_char = line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
		if current_char == trigger_char or (current_char == " " and prev_char == trigger_char) then
			return true
		end
	end
	return false
end

local function open_signature()
	local triggered = false

	for _, client in pairs(clients) do
		local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

		-- csharp has wrong trigger chars for some odd reason
		if client.name == "csharp" then
			triggers = { "(", "," }
		end

		local pos = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_get_current_line()
		local line_to_cursor = line:sub(1, pos[2])

		if not triggered then
			triggered = check_trigger_char(line_to_cursor, triggers)
		end
	end

	if triggered then
		local params = util.make_position_params()
		vim.lsp.buf_request(
			0,
			"textDocument/signatureHelp",
			params,
			vim.lsp.with(M.signature_window, {
				border = "single",
				focusable = false,
				silent = true,
			})
		)
	end
end

function M.setup_client(client)
	table.insert(clients, client)
	local group = augroup("LspSignature", { clear = true })
	vim.api.nvim_clear_autocmds({ group = group, pattern = "<buffer>" })

	autocmd("TextChangedI", {
		group = group,
		pattern = "<buffer>",
		callback = function()
			-- Guard against spamming of method not supprted after
			-- stopping a language server with LspStop
			if #vim.lsp.get_active_clients() < 1 then
				return
			end
			open_signature()
		end,
	})
end

function M.setup()
	local _start_client = vim.lsp.start_client

	vim.lsp.start_client = function(lsp_config)
		if lsp_config.on_attach == nil then
			lsp_config.on_attach = function(client, bufnr)
				M.setup_client(client)
			end
		else
			local _on_attach = lsp_config.on_attach
			lsp_config.on_attach = function(client, bufnr)
				M.setup_client(client)
				_on_attach(client, bufnr)
			end
		end
		return _start_client(lsp_config)
	end
end

return M
