# Vim general keybindings
''
  " ============================================================================
  " Keybindings
  " ============================================================================
  
  " General
  nnoremap <leader>w :w<CR>
  nnoremap <leader>q :q<CR>
  nnoremap <leader>cd :Ex<CR>

  " Undotree
  nnoremap <leader>u :UndotreeToggle<CR>

  " Fugitive (Git)
  nnoremap <leader>gs :Git<CR>

  " FZF - File finding
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fo :History<CR>
  nnoremap <leader>rg :Rg<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fh :Helptags<CR>

  " Quick access to startify
  nnoremap <leader>s :Startify<CR>

  " Window navigation
  nnoremap <C-Left> <C-w>h
  nnoremap <C-Down> <C-w>j
  nnoremap <C-Up> <C-w>k
  nnoremap <C-Right> <C-w>l

  " Better indenting
  vnoremap < <gv
  vnoremap > >gv

  " Move lines
  nnoremap <A-j> :m .+1<CR>==
  nnoremap <A-k> :m .-2<CR>==
  vnoremap <A-j> :m '>+1<CR>gv=gv
  vnoremap <A-k> :m '<-2<CR>gv=gv

  " Clear search highlight
  nnoremap <leader>h :nohlsearch<CR>

  " ============================================================================
  " The Primeagen's keybindings
  " ============================================================================

  " Quickfix navigation - next/previous error with centering
  nnoremap <C-k> :cnext<CR>zz
  nnoremap <C-j> :cprev<CR>zz

  " Location list navigation - next/previous with centering
  nnoremap <leader>k :lnext<CR>zz
  nnoremap <leader>j :lprev<CR>zz

  " Search and replace word under cursor
  nnoremap <leader>sr :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

  " Make current file executable
  nnoremap <silent> <leader>x :!chmod +x %<CR>

  " Greatest remap ever - paste without losing register
  xnoremap <leader>p "_dP

  " System clipboard yank
  nnoremap <leader>y "+y
  vnoremap <leader>y "+y
  nnoremap <leader>Y "+Y

  " Delete to void register (don't affect clipboard)
  nnoremap <leader>d "_d
  vnoremap <leader>d "_d

  " Center cursor when cycling through search results
  nnoremap n nzzzv
  nnoremap N Nzzzv
''
