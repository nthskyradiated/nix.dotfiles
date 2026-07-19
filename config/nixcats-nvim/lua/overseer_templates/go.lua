local util = require("overseer_templates.util")
local M = {}

function M.register(overseer)
	overseer.register_template({
		name = "build go project",
		builder = function()
			local root = util.find_root({ "go.mod" })

			if util.file_exists(root .. "/go.mod") then
				local bin_dir = root .. "/bin/"
				return {
					-- mkdir first: go build won't create a missing output directory itself
					cmd = { "sh", "-c", "mkdir -p '" .. bin_dir .. "' && go build -o '" .. bin_dir .. "' ./..." },
					cwd = root,
					components = { "default" },
				}
			end

			-- No go.mod: single-file build (this case already worked, since a
			-- lone main package is never treated as "multiple packages")
			local file = vim.fn.expand("%:p")
			local out = vim.fn.expand("%:p:r")
			return {
				cmd = { "go", "build", "-o", out, file },
				cwd = vim.fn.expand("%:p:h"),
				components = { "default" },
			}
		end,
		condition = {
			filetype = { "go" },
		},
		tags = { overseer.TAG.BUILD },
	})

	overseer.register_template({
		name = "go run",
		builder = function()
			local root = util.find_root({ "go.mod" })
			if util.file_exists(root .. "/go.mod") then
				return {
					cmd = { "go", "run", "." },
					cwd = root,
					components = { "default" },
				}
			end
			return {
				cmd = { "go", "run", vim.fn.expand("%:p") },
				cwd = vim.fn.expand("%:p:h"),
				components = { "default" },
			}
		end,
		condition = {
			filetype = { "go" },
		},
		tags = { overseer.TAG.RUN },
	})
end

return M
