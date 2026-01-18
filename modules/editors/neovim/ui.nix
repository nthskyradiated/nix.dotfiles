# Neovim UI configuration (theme, statusline, etc.)
''
  -- Theme
  require('tokyonight').setup({
    style = 'storm',
    transparent = true,

    on_highlights = function(hl, c)
      -- Line numbers
      hl.LineNr = {
        fg = "#5e8ed1", -- bluish gray
      }

      hl.LineNrAbove = {
        fg = "#5e8ed1",
      }

      hl.LineNrBelow = {
        fg = "#5e8ed1",
      }

      hl.CursorLineNr = {
        fg = "#89ddff", -- light / sky blue
        bold = true,
      }

      hl.CursorLine = {
        bg = "NONE",
      }
    end,
  })

  vim.cmd.colorscheme('tokyonight-storm')

  -- Statusline
  require('lualine').setup({
    options = {
      theme = 'tokyonight',
      component_separators = '|',
      section_separators = ' ',
    },
  })

  -- Gitsigns
  require('gitsigns').setup()

  -- Comment
  require('Comment').setup()

  -- Zen Mode
  require('zen-mode').setup()

  -- Which-key
  require('which-key').setup()
''

