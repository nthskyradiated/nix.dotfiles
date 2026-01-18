vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local ft = vim.bo[buf].filetype

		if ft == "" or ft == "netrw" or ft == "TelescopePrompt" or ft == "help" then
			return
		end

		pcall(vim.treesitter.start, buf)
	end,
})
