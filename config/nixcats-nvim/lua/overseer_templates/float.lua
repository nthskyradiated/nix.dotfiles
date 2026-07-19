local M = {}

local win, buf

local status_icons = {
	PENDING = { icon = "○", hl = "OverseerPENDING" },
	RUNNING = { icon = "", hl = "OverseerRUNNING" },
	SUCCESS = { icon = "✓", hl = "OverseerSUCCESS" },
	FAILURE = { icon = "✗", hl = "OverseerFAILURE" },
	CANCELED = { icon = "-", hl = "OverseerCANCELED" },
}

local function render()
	if not (buf and vim.api.nvim_buf_is_valid(buf)) then
		return
	end

	local overseer = require("overseer")
	local tasks = overseer.list_tasks({})

	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)

	if #tasks == 0 then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "  No tasks yet. Run <leader>ob to build." })
	else
		local lines = {}
		for _, task in ipairs(tasks) do
			local status = task.status or "PENDING"
			local meta = status_icons[status] or status_icons.PENDING
			table.insert(lines, string.format("  %s  %-10s  %s", meta.icon, status, task.name))
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

		local ns = vim.api.nvim_create_namespace("overseer_float")
		for i, task in ipairs(tasks) do
			local meta = status_icons[task.status] or status_icons.PENDING
			vim.api.nvim_buf_add_highlight(buf, ns, meta.hl, i - 1, 2, 5)
		end
	end

	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

function M.open()
	if win and vim.api.nvim_win_is_valid(win) then
		return
	end

	buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "OverseerFloat")

	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.4)

	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " Overseer Tasks ",
		title_pos = "center",
	})

	vim.keymap.set("n", "q", M.close, { buffer = buf, silent = true })
	vim.keymap.set("n", "<esc>", M.close, { buffer = buf, silent = true })
	vim.keymap.set("n", "<cr>", function()
		-- Jump to task under cursor via OverseerTaskAction on the matching line
		local line = vim.api.nvim_win_get_cursor(win)[1]
		local overseer = require("overseer")
		local tasks = overseer.list_tasks({})
		local task = tasks[line]
		if task then
			M.close()
			overseer.run_action(task, "open")
		end
	end, { buffer = buf, silent = true, desc = "Open task output" })

	render()

	-- Live refresh on status changes
	vim.api.nvim_create_autocmd("User", {
		pattern = "OverseerTaskUpdate",
		group = vim.api.nvim_create_augroup("OverseerFloatRefresh", { clear = true }),
		callback = render,
	})
end

function M.close()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
	win, buf = nil, nil
	pcall(vim.api.nvim_del_augroup_by_name, "OverseerFloatRefresh")
end

function M.toggle()
	if win and vim.api.nvim_win_is_valid(win) then
		M.close()
	else
		M.open()
	end
end

function M.setup()
	-- nothing to init eagerly; kept for symmetry with other modules
end

return M
