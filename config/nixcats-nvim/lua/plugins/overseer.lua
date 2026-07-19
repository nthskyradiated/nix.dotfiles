local overseer = require("overseer")

-- Use nvim-notify as the default notification backend so Overseer's
-- success/failure messages render as floats instead of plain echo
require("notify").setup({
	stages = "fade_in_slide_out",
	timeout = 6000,
	render = "compact",
	top_down = false,
})
vim.notify = require("notify")

overseer.setup({
	templates = { "builtin" },
	task_list = {
		direction = "bottom",
		min_height = 15,
		max_height = 25,
		default_detail = 1,
	},
	-- IMPORTANT: do NOT include the string "default" inside this list —
	-- that causes infinite self-referential recursion (stack overflow).
	-- This is a full, explicit rewrite of the built-in default, with
	-- notifications filtered to skip "CANCELED" noise.
	component_aliases = {
		default = {
			"on_exit_set_status",
			{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
			{ "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
		},
	},
})

require("overseer_templates").register_all(overseer)
require("overseer_templates.float").setup()

-- Keymaps
vim.keymap.set("n", "<leader>ob", function()
	overseer.run_task({ tags = { overseer.TAG.BUILD } })
end, { desc = "Overseer: Build (auto-detect)" })

vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Overseer: Run task" })
vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Overseer: Toggle task list (panel)" })
vim.keymap.set("n", "<leader>oa", "<cmd>OverseerTaskAction<cr>", { desc = "Overseer: Task action" })

vim.keymap.set("n", "<leader>ol", function()
	require("overseer_templates.float").toggle()
end, { desc = "Overseer: Toggle task list (float)" })

-- Auto-build on save for supported filetypes
local build_group = vim.api.nvim_create_augroup("OverseerAutoBuild", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = build_group,
	pattern = { "*.c", "*.h", "*.go", "*.zig" },
	callback = function()
		overseer.run_task({ tags = { overseer.TAG.BUILD } }, function(task, err)
			if err then
				vim.notify("Overseer build failed to start: " .. err, vim.log.levels.ERROR)
			end
		end)
	end,
})
