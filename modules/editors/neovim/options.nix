# Updated options.lua - Shows LSP diagnostics, hides nvim-lint until enabled
''
              -- Basic settings
              vim.opt.number = true
              vim.opt.relativenumber = true
              vim.opt.cursorline = true
              vim.opt.mouse = 'a'
              vim.opt.ignorecase = true
              vim.opt.smartcase = true
              vim.opt.hlsearch = false
              vim.opt.wrap = false
              vim.opt.breakindent = true
              vim.opt.tabstop = 2
              vim.opt.shiftwidth = 2
              vim.opt.expandtab = true
              vim.opt.smartindent = true
              vim.opt.signcolumn = 'yes'
              vim.opt.updatetime = 250
              vim.opt.timeoutlen = 300
              vim.opt.completeopt = 'menu,menuone,noselect'

              -- Search settings
              vim.opt.incsearch = true
              vim.opt.scrolloff = 8

              -- Undo settings
              vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
              vim.opt.undofile = true

    -- ============================================================================
  -- LSP Diagnostics Control
  -- ============================================================================

  -- Configure diagnostics display - virtual text disabled by default
  vim.diagnostic.config({
    virtual_text = false,  -- Disabled, will be shown only on current line
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Custom highlight for diagnostic virtual text
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { 
    fg = '#F7768E', 
    bold = true,
    italic = true 
  })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { 
    fg = '#E0AF68', 
    bold = true,
    italic = true 
  })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { 
    fg = '#7AA2F7', 
    bold = true,
    italic = true 
  })

  -- ============================================================================
  -- Virtual Text on Current Line Only (ALE-like behavior)
  -- ============================================================================

  local show_virt_text_severity = vim.diagnostic.severity.ERROR
  local ns = vim.api.nvim_create_namespace('current_line_virt_text')

  local function update_current_line_virt_text()
    -- Only run if linting is enabled
    if not vim.g.lint_enabled then
      return
    end

    -- Clear previous virtual text
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

    -- Get current line
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics_on_line = vim.diagnostic.get(0, { lnum = lnum })

    -- Filter by severity if needed
    local filtered = {}
    for _, diag in ipairs(diagnostics_on_line) do
      if diag.severity <= show_virt_text_severity then
        table.insert(filtered, diag)
      end
    end

    -- Show virtual text only on current line
    if not vim.tbl_isempty(filtered) then
      for _, diag in ipairs(filtered) do
        local source = diag.source or "unknown"
        local message = diag.message
        local code = diag.code and " (" .. diag.code .. ")" or ""
        local text = string.format("● %s [%s]%s", message, source, code)
        
        local hl_group = "DiagnosticVirtualTextError"
        if diag.severity == vim.diagnostic.severity.WARN then
          hl_group = "DiagnosticVirtualTextWarn"
        elseif diag.severity == vim.diagnostic.severity.INFO or diag.severity == vim.diagnostic.severity.HINT then
          hl_group = "DiagnosticVirtualTextInfo"
        end

        vim.api.nvim_buf_set_extmark(0, ns, lnum, 0, {
          virt_text = {{text, hl_group}},
          virt_text_pos = 'eol',
        })
      end
    end
  end

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'DiagnosticChanged' }, {
    group = vim.api.nvim_create_augroup('diagnostic_current_line_only', { clear = true }),
    callback = update_current_line_virt_text
  })

  -- Redraw diagnostics when mode changes
  vim.api.nvim_create_autocmd('ModeChanged', {
    group = vim.api.nvim_create_augroup('diagnostic_redraw', { clear = true }),
    callback = function()
      update_current_line_virt_text()
    end
  })

  -- ============================================================================
  -- Keymaps
  -- ============================================================================

  -- Toggle ALL diagnostics (LSP + nvim-lint) on/off
  vim.keymap.set('n', '<leader>td', function()
    if vim.diagnostic.is_enabled() then
      vim.diagnostic.disable()
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      print("✗ All diagnostics disabled")
    else
      vim.diagnostic.enable()
      update_current_line_virt_text()
      print("✓ All diagnostics enabled")
    end
  end, { desc = 'Toggle all diagnostics' })

  -- View diagnostics on demand
  vim.keymap.set('n', '<leader>ln', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
  vim.keymap.set('n', '[l', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
  vim.keymap.set('n', ']l', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

  -- Jump only to errors
  vim.keymap.set('n', '[e', function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = 'Previous error' })
  vim.keymap.set('n', ']e', function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = 'Next error' })

  -- Toggle showing ALL diagnostics inline (including warnings)
  vim.keymap.set('n', '<leader>tv', function()
    if show_virt_text_severity == vim.diagnostic.severity.ERROR then
      -- Show ALL
      show_virt_text_severity = vim.diagnostic.severity.HINT
      print("✓ Showing ALL diagnostics inline")
    else
      -- Show only errors
      show_virt_text_severity = vim.diagnostic.severity.ERROR
      print("✓ Showing only ERRORS inline")
    end
    update_current_line_virt_text()
  end, { desc = 'Toggle diagnostic virtual text' })
''
