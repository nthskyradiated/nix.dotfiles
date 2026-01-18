# Neovim navigation configuration (Telescope, Harpoon)
''
  -- Telescope
  local telescope = require('telescope')
  local builtin = require('telescope.builtin')

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }
    }
  })

  telescope.load_extension('fzf')

  -- Telescope keymaps
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
  vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })

  -- Harpoon
  local harpoon = require('harpoon')
  harpoon:setup()

  vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon add' })
  vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
  vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
  vim.keymap.set('n', '<C-j>', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
  vim.keymap.set('n', '<C-k>', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
  vim.keymap.set('n', '<C-l>', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })
''
