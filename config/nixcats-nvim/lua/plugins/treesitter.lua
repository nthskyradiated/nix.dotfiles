-- Tree-sitter configuration (Nix-safe, rewritten API compatible)

local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	return
end

-- Explicitly start Tree-sitter highlighting when a parser exists
vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Optional: disable regex syntax if Tree-sitter attaches
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
			vim.cmd("syntax off")
		end
	end,
})

-- Disable LSP semantic tokens when Tree-sitter is active
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and vim.treesitter.highlighter.active[args.buf] then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})
