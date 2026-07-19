local util = require("overseer_templates.util")
local M = {}

function M.register(overseer)
	overseer.register_template({
		name = "build zig project",
		builder = function()
			local root = util.find_root({ "build.zig" })

			if util.file_exists(root .. "/build.zig") then
				return {
					cmd = { "zig", "build" },
					cwd = root,
					components = { "default" },
				}
			end

			-- No build.zig: build the current file standalone
			local file = vim.fn.expand("%:p")
			local out_dir = vim.fn.expand("%:p:h")
			return {
				cmd = { "zig", "build-exe", file, "-femit-bin=" .. out_dir .. "/" .. vim.fn.expand("%:t:r") },
				cwd = out_dir,
				components = { "default" },
			}
		end,
		condition = {
			filetype = { "zig" },
		},
		tags = { overseer.TAG.BUILD },
	})
end

return M
