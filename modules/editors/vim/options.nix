# Vim editor options
''
      " ============================================================================
      " Leader key
      " ============================================================================
      let mapleader = " "
      let maplocalleader = " "

      " ============================================================================
      " Basic settings
      " ============================================================================
      set nocompatible
      set hidden
      set updatetime=300
      set signcolumn=yes
      set cmdheight=2
      set shortmess+=c
      set completeopt=menu,menuone,noselect
      set smartindent

      " Line numbers
      set number
      set relativenumber

      " Transparency/opacity
      if has('termguicolors')
        set termguicolors
      endif

      " Window transparency (works in terminals that support it)
      highlight Normal guibg=NONE ctermbg=NONE
      highlight NonText guibg=NONE ctermbg=NONE
      highlight LineNr guibg=NONE ctermbg=NONE
      highlight SignColumn guibg=NONE ctermbg=NONE
      highlight EndOfBuffer guibg=NONE ctermbg=NONE

    " ============================================================================
    " ALE Virtual Text Highlight Colors
    " ============================================================================

    " Apply custom highlight colors after colorscheme loads
    augroup CustomHighlights
      autocmd!
      autocmd ColorScheme * highlight ALEVirtualTextError guifg=#A96A7C 
      autocmd ColorScheme * highlight ALEVirtualTextWarning guifg=#A88B5A 
      autocmd ColorScheme * highlight ALEVirtualTextInfo guifg=#6F88AA 
    augroup END

    " Also set them immediately for current session
  highlight ALEVirtualTextError guifg=#A96A7C 
  highlight ALEVirtualTextWarning guifg=#A88B5A 
  highlight ALEVirtualTextInfo guifg=#6F88AA 

      " Search settings
      set incsearch
      set scrolloff=8

      " Undo settings
      set undodir=$HOME/.vim/undodir
      set undofile

      " ============================================================================
      " Diagnostic Display Control
      " ============================================================================

      " Global state for diagnostics
      let g:diagnostics_enabled = 1
      let g:diagnostics_virtual_text_all = 0

      " Toggle ALL diagnostics (vim-lsp)
      function ToggleDiagnostics() abort
        if g:diagnostics_enabled
          " Disable vim-lsp diagnostics
          let g:diagnostics_enabled = 0
          let g:lsp_diagnostics_enabled = 0
          let g:lsp_diagnostics_signs_enabled = 0
          let g:lsp_diagnostics_virtual_text_enabled = 0
          let g:lsp_diagnostics_highlights_enabled = 0
          
          " Clear display
          sign unplace *
          if exists('*prop_clear')
            call prop_clear(1, line('$'))
          endif
          
          echom '✗ LSP diagnostics disabled'
        else
          " Enable vim-lsp diagnostics
          let g:diagnostics_enabled = 1
          let g:lsp_diagnostics_enabled = 1
          let g:lsp_diagnostics_signs_enabled = 1
          let g:lsp_diagnostics_virtual_text_enabled = 1
          let g:lsp_diagnostics_highlights_enabled = 1
          
          echom '✓ LSP diagnostics enabled'
          
          " Refresh
          if exists(':LspDocumentDiagnostics')
            silent! LspDocumentDiagnostics
          endif
        endif
      endfunction

      " Toggle virtual text severity (errors only vs all)
      function ToggleVirtualTextSeverity() abort
        if !g:diagnostics_enabled
          echom '✗ Diagnostics disabled. Enable with <leader>td first'
          return
        endif
        
        if g:diagnostics_virtual_text_all
          let g:diagnostics_virtual_text_all = 0
          echom '✓ Showing only ERRORS inline (LSP)'
        else
          let g:diagnostics_virtual_text_all = 1
          echom '✓ Showing ALL diagnostics inline (LSP)'
        endif
        
        " Note: vim-lsp doesn't have easy per-severity filtering
        " This is more of a visual toggle indicator
      endfunction

      " Show diagnostic details
      function ShowDiagnosticDetails() abort
        if !g:diagnostics_enabled
          echom '✗ Diagnostics disabled'
          return
        endif
        
        if exists(':LspHover')
          LspHover
        endif
      endfunction

      " ============================================================================
      " Diagnostic Navigation and Control Keymaps
      " ============================================================================

      " Toggle LSP diagnostics
      nnoremap <leader>td :call ToggleDiagnostics()<CR>

      " Toggle virtual text severity
      nnoremap <leader>tv :call ToggleVirtualTextSeverity()<CR>

      " Show diagnostic details
      nnoremap <leader>ln :call ShowDiagnosticDetails()<CR>

      " Navigate between LSP diagnostics
      nnoremap [d :LspPreviousDiagnostic<CR>
      nnoremap ]d :LspNextDiagnostic<CR>

      " Navigate errors (same as all diagnostics in vim-lsp)
      nnoremap [e :LspPreviousDiagnostic<CR>
      nnoremap ]e :LspNextDiagnostic<CR>

      " Show all diagnostics in location list
      nnoremap <leader>lq :LspDocumentDiagnostics<CR>

      " ============================================================================
      " File type specific settings
      " ============================================================================
      augroup FileTypeSettings
        autocmd!
        autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
        autocmd FileType python setlocal tabstop=4 shiftwidth=4
        autocmd FileType javascript,typescript,json,yaml setlocal tabstop=2 shiftwidth=2
      augroup END

      " ============================================================================
      " Status Information
      " ============================================================================

      function PrintStartupStatus() abort
        echom '═══════════════════════════════════════════════════════'
        echom 'LSP diagnostics: enabled (toggle: <leader>td)'
        echom 'Extra linting (ALE): disabled (toggle: <leader>lt)'
        echom 'Kubernetes YAML: kubeconform + yamllint (when ALE on)'
        echom 'Navigation: [d/]d (LSP) | [a/]a (ALE extra)'
        echom '═══════════════════════════════════════════════════════'
      endfunction

      autocmd VimEnter * call timer_start(100, {-> execute('call PrintStartupStatus()')})
''
