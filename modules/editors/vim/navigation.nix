# Vim navigation configuration (FZF, Startify)
''
  " ============================================================================
  " FZF Configuration
  " ============================================================================
  " Use ripgrep for FZF if available
  if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  endif

  " FZF window settings
  let g:fzf_layout = { 'down': '40%' }
  let g:fzf_preview_window = ['right:50%', 'ctrl-/']

  " Customize fzf colors to match tokyonight
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }

  " ============================================================================
  " Startify (Harpoon alternative - quick file access)
  " ============================================================================
  let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   Recent Files']            },
    \ { 'type': 'dir',       'header': ['   Recent Files in '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ ]
  
  let g:startify_bookmarks = [
    \ { 'c': '~/.config' },
    \ { 'n': '~/.config/nixos' },
    \ ]
  
  let g:startify_session_autoload = 1
  let g:startify_session_persistence = 1
  let g:startify_change_to_vcs_root = 1
''
