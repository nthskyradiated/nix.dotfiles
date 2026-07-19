local M = {}

-- Find the nearest ancestor directory containing any of `markers`,
-- starting from the current buffer's directory. Falls back to cwd.
function M.find_root(markers)
	local buf_dir = vim.fn.expand("%:p:h")
	local found = vim.fs.find(markers, {
		path = buf_dir,
		upward = true,
		type = "file",
	})[1]

	if found then
		return vim.fs.dirname(found)
	end

	return vim.fn.getcwd()
end

function M.file_exists(path)
	return vim.fn.filereadable(path) == 1
end

return M
