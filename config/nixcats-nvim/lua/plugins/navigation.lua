local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })

local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Harpoon add" })
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<C-j>", function()
	harpoon:list():select(2)
end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<C-k>", function()
	harpoon:list():select(3)
end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<C-l>", function()
	harpoon:list():select(4)
end, { desc = "Harpoon 4" })

-- Neo-tree (sidebar)
local ok, neotree = pcall(require, "neo-tree")
if ok then
	neotree.setup({
		open_on_setup = false,
		open_on_setup_file = false,

		close_if_last_window = true,

		enable_git_status = true,
		enable_diagnostics = true,

		window = {
			position = "left",
			width = 32,
			mappings = {
				["<space>"] = "toggle_node",
				["<cr>"] = "open",
				["l"] = "open",
				["h"] = "close_node",
				["q"] = "close_window",
			},
		},
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 1,
				with_markers = false,
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "",
				default = "",
			},
			modified = {
				symbol = "●",
				highlight = "NeoTreeModified",
			},
			git_status = {
				symbols = {
					added = "A",
					modified = "M",
					deleted = "D",
					renamed = "R",
					untracked = "U",
					ignored = "◌",
					unstaged = "",
					staged = "✓",
					conflict = "",
				},
			},
		},

		filesystem = {
			follow_current_file = {
				enabled = false,
			},
			bind_to_cwd = false,
			hijack_netrw_behavior = "disabled",

			use_libuv_file_watcher = true,
		},
	})

	vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer" })
	vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Explorer focus" })
	vim.keymap.set("n", "<leader>gs", "<cmd>Neotree git_status<cr>", { desc = "Git sidebar" })
end
