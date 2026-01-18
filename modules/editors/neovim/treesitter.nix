# Neovim Treesitter configuration
{ pkgs, ... }:

''
  -- Treesitter: Enable highlighting and indentation via native Neovim API
  -- Parsers are already installed via Nix (plugins.nix)

  -- Enable treesitter highlighting for supported filetypes only
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo[buf].filetype
      
      -- Skip special buffers and filetypes without parsers
      if ft == ''' or ft == 'netrw' or ft == 'TelescopePrompt' or ft == 'help' then
        return
      end
      
      -- Try to start treesitter, silently fail if no parser available
      pcall(vim.treesitter.start, buf)
    end,
  })
''
