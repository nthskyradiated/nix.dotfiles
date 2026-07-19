local util = require("overseer_templates.util")
local M = {}

function M.register(overseer)
	overseer.register_template({
		name = "build c project",
		builder = function()
			local root = util.find_root({ "Makefile", "makefile", "CMakeLists.txt" })

			if util.file_exists(root .. "/CMakeLists.txt") then
				return {
					cmd = { "sh", "-c", "cmake -S . -B build && cmake --build build" },
					cwd = root,
					components = { "default" },
				}
			end

			if util.file_exists(root .. "/Makefile") or util.file_exists(root .. "/makefile") then
				return {
					cmd = { "make" },
					cwd = root,
					components = { "default" },
				}
			end

			-- No build system found: compile the current file standalone
			local file = vim.fn.expand("%:p")
			local out = vim.fn.expand("%:p:r")
			return {
				cmd = { "gcc", "-g", "-Wall", "-Wextra", file, "-o", out },
				cwd = vim.fn.expand("%:p:h"),
				components = { "default" },
			}
		end,
		condition = {
			filetype = { "c" },
		},
		tags = { overseer.TAG.BUILD },
	})
end

return M
