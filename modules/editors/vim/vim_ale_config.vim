
  " ============================================================================
  " ALE Configuration - Extra Validation Layer
  " ============================================================================
  
  " DISABLED by default - only runs on command
  let g:ale_enabled = 1
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_insert_leave = 0
  let g:ale_lint_on_enter = 0
  let g:ale_lint_on_save = 0
  let g:ale_lint_on_filetype_changed = 0

  " Configure linters - use specialized tools that add value beyond LSP
  let g:ale_linters = {
  \   'go': ['golangci-lint'],
  \   'python': ['pylint'],
  \   'dockerfile': ['hadolint'],
  \   'markdown': ['markdownlint'],
  \   'yaml': ['yamllint'],
  \}

  " Disable fixers (we use LSP for formatting)
  let g:ale_fixers = {}
  let g:ale_fix_on_save = 0

  " Configure display
  let g:ale_sign_error = '✗'
  let g:ale_sign_warning = '⚠'
  let g:ale_sign_info = '💡'
  let g:ale_echo_cursor = 1
  let g:ale_echo_delay = 100
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  
  " Virtual text configuration
  let g:ale_virtualtext_cursor = 'current'
  let g:ale_virtualtext_prefix = '◆ '
  let g:ale_virtualtext_delay = 100
  
  " Only show errors inline by default
  let g:ale_virtualtext_severity = 'error'

  " Configure specific linters
  let g:ale_go_golangci_lint_options = '--fast'
  let g:ale_go_golangci_lint_package = 1

  " ============================================================================
  " Helper Functions
  " ============================================================================
  
  " Clear ALE diagnostics
  function ClearALEDiagnostics() abort
    if exists(':ALEReset')
      ALEReset
    endif
  endfunction

  " Toggle ALE on/off
  function ToggleALE() abort
    if g:ale_enabled
      let g:ale_enabled = 0
      let g:ale_lint_on_save = 0
      call ClearALEDiagnostics()
      echom '✗ Extra linting disabled (LSP still active)'
    else
      let g:ale_enabled = 1
      let g:ale_lint_on_save = 1
      echom '✓ Extra linting enabled (ALE)'
      
      " Run linting immediately
      if &modifiable && &filetype !=# ''
        ALELint
      endif
    endif
  endfunction

  " Run linting manually
  function RunALELint() abort
      echom 'Extra linting disabled. Enable with :LintToggle or <leader>lt'
  endfunction

  " Toggle showing ALL ALE diagnostics inline (including warnings)
  function ToggleALEVirtualText() abort
    if !g:ale_enabled
      echom '✗ Extra linting disabled. Enable with <leader>lt first'
      return
    endif
    
    if g:ale_virtualtext_severity ==# 'error'
      let g:ale_virtualtext_severity = 'all'
      echom '✓ Showing ALL extra lint diagnostics inline'
    else
      let g:ale_virtualtext_severity = 'error'
      echom '✓ Showing only extra lint ERRORS inline'
    endif
  endfunction

  " ============================================================================
  " Commands
  " ============================================================================
  
  command! Lint call RunALELint()
  command! LintToggle call ToggleALE()
  command! LintEnable let g:ale_enabled = 1 | let g:ale_lint_on_save = 1 | echom '✓ Extra linting enabled'
  command! LintDisable let g:ale_enabled = 0 | let g:ale_lint_on_save = 0 | call ClearALEDiagnostics() | echom '✗ Extra linting disabled'
  
  " ============================================================================
  " Keymaps
  " ============================================================================
  
  " Run extra linting
  nnoremap <leader>ll :call RunALELint()<CR>
  
  " Toggle extra linting on/off
  nnoremap <leader>lt :call ToggleALE()<CR>
  
  " Navigate between ALE diagnostics
  nmap <silent> [a <Plug>(ale_previous_wrap)
  nmap <silent> ]a <Plug>(ale_next_wrap)
  
  " Show ALE diagnostic details
  nnoremap <leader>la :ALEDetail<CR>
  
  " Toggle ALE virtual text severity
  nnoremap <leader>lv :call ToggleALEVirtualText()<CR>

  " ============================================================================
  " Status
  " ============================================================================
  
  echom 'LSP diagnostics: always on'
  echom 'Extra linting (ALE): disabled by default (toggle with <leader>lt)'


