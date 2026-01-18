''
  " ============================================================================
  " Theme
  " ============================================================================
  set background=dark
  let g:tokyonight_style = 'night'
  let g:tokyonight_enable_italic = 1
  let g:tokyonight_transparent_background = 1

  colorscheme tokyonight

  " ============================================================================
  " Line number colors (post-colorscheme, persistent)
  " ============================================================================
  augroup VimLineNumberColors
    autocmd!
    autocmd ColorScheme * highlight LineNr guifg=#5e8ed1 guibg=NONE ctermfg=60 ctermbg=NONE
    autocmd ColorScheme * highlight CursorLineNr guifg=#89ddff gui=bold guibg=NONE cterm=bold ctermfg=117 ctermbg=NONE
    autocmd ColorScheme * highlight CursorLine guibg=NONE ctermbg=NONE
  augroup END

  set number
  set relativenumber
  set cursorline

  " ============================================================================
  " Lightline
  " ============================================================================
  let g:lightline = {
    \ 'colorscheme': 'tokyonight',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ }

  set laststatus=2
  set noshowmode

  " ============================================================================
  " GitGutter (symbols only)
  " ============================================================================
  let g:gitgutter_sign_added = '+'
  let g:gitgutter_sign_modified = '~'
  let g:gitgutter_sign_removed = '-'
  let g:gitgutter_sign_removed_first_line = '^'
  let g:gitgutter_sign_modified_removed = '~'
''

