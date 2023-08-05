-- LSP <start>
local function next_diagnostic()
	vim.diagnostic.goto_next({ border = true })
end

local function prev_diagnostic()
	vim.diagnostic.goto_prev({ border = true })
end

local function line_diagnostics()
	vim.diagnostic.open_float({ border = "rounded" })
end

local function fmt()
	vim.lsp.buf.formar()
end
-- LSP <end>

local function new_term()
	local ok, term = pcall(require, "toggleterm.terminal")
	if not ok then
		return function()
			print("Failed to require 'toggleterm.terminal'")
		end
	end
	local active_term = nil
	return function()
		if active_term == nil then
			active_term = term.Terminal:new({
				direction = "horizontal",
			})
		end
		active_term:toggle()
	end
end

local function custom_toggle_term()
	local ok, term = pcall(require, "toggleterm.terminal")
	if not ok then
		return function()
			print("failed to require 'toggleterm.terminal'")
		end
	end
	local active = nil
	return function()
		if active == nil then
			active = term.Terminal:new({
				direction = "float",
			})
		end
		active:toggle()
	end
end

local function telescope()
	local t_ok, builtin = pcall(require, "telescope.builtin")
	if not t_ok then
		error("telescope.builtin failed to be required.")
	end
	local theme_ok, themes = pcall(require, "telescope.themes")
	if not theme_ok then
		error("telescope.themes failed to be required.")
	end
	return builtin, themes
end

local function find_files()
	local ok, builtin, themes = pcall(telescope)
	if not ok then
		return
	end
	builtin.find_files(themes.get_dropdown({ previewer = false }))
end

local function buffers()
	local ok, builtin, themes = pcall(telescope)
	if not ok then
		return
	end
	builtin.buffers(themes.get_dropdown({ previewer = false }))
end

local function save_source()
	vim.cmd("w")
	vim.cmd("so")
end

local function nvim_tree_focus_toggle()
	local winNum = vim.api.nvim_get_current_win()
	vim.api.nvim_create_autocmd("WinEnter", {
		callback = function()
			if vim.bo.filetype ~= "NvimTree" then
				winNum = vim.api.nvim_get_current_win()
			end
		end,
	})
	return function()
		if vim.bo.filetype == "NvimTree" then
			vim.api.nvim_set_current_win(winNum)
		else
			vim.cmd("NvimTreeFocus")
		end
	end
end

local function buffer_kill()
	local kill_command = "bd!"

	local bo = vim.bo
	local api = vim.api

	local bufnr = api.nvim_get_current_buf()

	-- Get list of windows IDs with the buffer to close
	local windows = vim.tbl_filter(function(win)
		return api.nvim_win_get_buf(win) == bufnr
	end, api.nvim_list_wins())

	if #windows == 0 then
		return
	end

	-- Get list of active buffers
	local current_buffers = vim.tbl_filter(function(buf)
		return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
	end, api.nvim_list_bufs())

	-- If there is only one buffer (which has to be the current one), vim will
	-- create a new buffer on :bd.
	-- For more than one buffer, pick the previous buffer (wrapping around if necessary)
	if #current_buffers > 1 then
		for i, v in ipairs(current_buffers) do
			if v == bufnr then
				local prev_buf_idx = i == 1 and (#current_buffers - 1) or (i - 1)
				local prev_buffer = current_buffers[prev_buf_idx]
				for _, win in ipairs(windows) do
					api.nvim_win_set_buf(win, prev_buffer)
				end
			end
		end
	end

	-- Check if buffer still exists, to ensure the target buffer wasn't killed
	-- due to options like bufhidden=wipe.
	if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
		vim.cmd(string.format("%s %d", kill_command, bufnr))
	end
end
