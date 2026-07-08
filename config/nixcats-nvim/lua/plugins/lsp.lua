local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("plugins.lsp.yaml").setup(capabilities)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, opts)
	end,
})

vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
	capabilities = capabilities,
})

vim.lsp.config("eslint", {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
	root_markers = { ".eslintrc", ".eslintrc.js", "eslint.config.js", ".eslintrc.json", "package.json" },
	capabilities = capabilities,
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

vim.lsp.config("helm_ls", {
	cmd = { "helm_ls", "serve" },
	filetypes = { "helm", "yaml.helm-values", "templates/*.yaml", "templates/*.yml" },
	root_markers = { "Chart.yaml", "chart.yaml", "chart.yml", "Chart.yml", ".git" },
	capabilities = capabilities,
})

vim.lsp.config("tofu-ls", {
	cmd = { "tofu-ls", "serve" },
	filetypes = { "terraform", "tf" },
	root_markers = { ".terraform", ".git" },
	capabilities = capabilities,
})

vim.lsp.config("jsonls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	capabilities = capabilities,
})

vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
	capabilities = capabilities,
})

vim.lsp.config("zls", {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "zls.json", ".git" },
	capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", "stylua.toml", ".git" },
	capabilities = capabilities,
})

vim.lsp.config("clangd", {
	cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
	capabilities = capabilities,
})

require("clangd_extensions").setup({
	server = {}, -- clangd is already configured above via vim.lsp.config
	extensions = {
		autoSetHints = true,
		inlay_hints = {
			inline = false,
			show_parameter_hints = true,
			show_variable_name = true,
		},
	},
})

vim.lsp.config("svelte", {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	root_markers = { "package.json", "svelte.config.js" },
	capabilities = capabilities,
})

vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	capabilities = capabilities,
})

vim.lsp.config("dockerls", {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile" },
	capabilities = capabilities,
})

vim.lsp.config("nil_ls", {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", "flake.lock", ".git" },
	capabilities = capabilities,
	settings = {
		["nil"] = {
			formatting = {
				command = { "nixpkgs-fmt" },
			},
		},
	},
})

vim.lsp.enable({
	"helm_ls",
	"ts_ls",
	"eslint",
	"gopls",
	"tofu-ls",
	"jsonls",
	"yamlls",
	"pyright",
	"zls",
	"svelte",
	"bashls",
	"dockerls",
	"nil_ls",
	"clangd",
	"lua_ls",
})

require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "yamlfmt" },
		["yaml.ansible"] = { "yamlfmt" },
		["yaml.docker-compose"] = { "yamlfmt" },
		markdown = { "prettier" },
		go = { "gofmt" },
		python = { "isort", "black" },
		lua = { "stylua" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		terraform = { "tofu_fmt" },
		nix = { "nixpkgs_fmt" },
	},
	formatters = {
		nixpkgs_fmt = {
			command = "nixpkgs-fmt",
			args = {},
			stdin = true,
		},
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})

vim.api.nvim_create_user_command("LspInfo", function()
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		print(c.name)
	end
end, { desc = "List attached LSP clients" })
