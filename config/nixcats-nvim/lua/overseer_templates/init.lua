local M = {}

function M.register_all(overseer)
	local langs = { "c", "go", "zig" }
	for _, lang in ipairs(langs) do
		require("overseer_templates." .. lang).register(overseer)
	end
end

return M
