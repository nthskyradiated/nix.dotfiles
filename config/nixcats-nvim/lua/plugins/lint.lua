local lint = require("lint")

vim.g.lint_enabled = false

lint.linters_by_ft = {
	go = { "golangci_lint" },
	dockerfile = { "hadolint" },
	yaml = { "yamllint" },
	markdown = { "markdownlint" },
	python = { "pylint" },
}

lint.linters.golangci_lint = {
	cmd = "golangci-lint",
	args = { "run", "--out-format", "json", "--issues-exit-code=0" },
	stdin = false,
	stream = "stdout",
	ignore_exitcode = true,
	parser = function(output, bufnr)
		local diagnostics = {}
		if not output or output == "" then
			return diagnostics
		end

		local ok, data = pcall(vim.json.decode, output)
		if ok and data and data.Issues then
			for _, issue in ipairs(data.Issues) do
				if issue.Pos then
					table.insert(diagnostics, {
						lnum = (issue.Pos.Line or 1) - 1,
						col = (issue.Pos.Column or 1) - 1,
						end_lnum = (issue.Pos.Line or 1) - 1,
						end_col = (issue.Pos.Column or 1),
						severity = issue.Severity == "error" and vim.diagnostic.severity.ERROR
							or issue.Severity == "warning" and vim.diagnostic.severity.WARN
							or vim.diagnostic.severity.INFO,
						message = issue.Text or "golangci-lint issue",
						source = "golangci-lint",
						code = issue.FromLinter,
					})
				end
			end
		end
		return diagnostics
	end,
}

local function clear_lint_diagnostics()
	local ns = vim.api.nvim_create_namespace("lint")
	pcall(function()
		vim.diagnostic.reset(ns, 0)
	end)
end

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = lint_augroup,
	callback = function()
		if vim.g.lint_enabled and vim.bo.modifiable and vim.bo.filetype ~= "" then
			vim.defer_fn(function()
				lint.try_lint()
			end, 100)
		end
	end,
})

vim.api.nvim_create_user_command("Lint", function()
	if vim.g.lint_enabled then
		lint.try_lint()
	else
		print("Linting disabled. Enable with :LintEnable or <leader>lt")
	end
end, { desc = "Run linting" })

vim.api.nvim_create_user_command("LintToggle", function()
	vim.g.lint_enabled = not vim.g.lint_enabled
	if vim.g.lint_enabled then
		print("✓ Extra linting enabled (nvim-lint)")
		if vim.bo.modifiable and vim.bo.filetype ~= "" then
			vim.defer_fn(function()
				lint.try_lint()
			end, 100)
		end
	else
		print("✗ Extra linting disabled (LSP still active)")
		clear_lint_diagnostics()
	end
end, { desc = "Toggle nvim-lint" })

-- Keymaps
vim.keymap.set("n", "<leader>ll", function()
	if vim.g.lint_enabled then
		lint.try_lint()
	else
		print("Extra linting disabled. Use <leader>lt to enable")
	end
end, { desc = "Run extra linting" })

vim.keymap.set("n", "<leader>lt", function()
	vim.g.lint_enabled = not vim.g.lint_enabled
	if vim.g.lint_enabled then
		print("✓ Extra linting enabled")
		if vim.bo.modifiable and vim.bo.filetype ~= "" then
			vim.defer_fn(function()
				lint.try_lint()
			end, 100)
		end
	else
		print("✗ Extra linting disabled")
		clear_lint_diagnostics()
	end
end, { desc = "Toggle extra linting" })

print("LSP diagnostics: always on (toggle with <leader>td)")
print("Extra linting (nvim-lint): disabled by default (toggle with <leader>lt)")
