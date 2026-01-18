# Neovim general keybindings
''
  -- General keymaps
  vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
  vim.keymap.set('n', '<leader>cd', '<cmd>Ex<CR>', { desc = 'Explorer' })
  
  -- Zen mode
  vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Toggle Zen Mode' })
  
  -- Undotree
  vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree' })
  
  -- Fugitive (Git)
  vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' })
  
  -- Window navigation
  vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = 'Window left' })
  vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = 'Window down' })
  vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = 'Window up' })
  vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Window right' })

  -- Better indenting
  vim.keymap.set('v', '<', '<gv')
  vim.keymap.set('v', '>', '>gv')

  -- Move lines
  vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
  vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
  vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move lines down' })
  vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move lines up' })

  -- ===========================================================================
  -- The Primeagen's keybindings
  -- ===========================================================================
  
   -- Quickfix navigation - next/previous error with centering (using Ctrl+Shift)
  vim.keymap.set('n', '<leader>ck', '<cmd>cnext<CR>zz', { desc = 'Next quickfix item' })
  vim.keymap.set('n', '<leader>cj', '<cmd>cprev<CR>zz', { desc = 'Previous quickfix item' }) 

  -- Location list navigation - next/previous with centering
  vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Next location item' })
  vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Previous location item' })
  
  -- Search and replace word under cursor
  vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor' })

  -- Always place cursor to the center when cycling to searches
  vim.keymap.set("n", "n", "nzzzv")
  vim.keymap.set("n", "N", "Nzzzv")

  -- Make current file executable
  vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make file executable' })
  
  -- Greatest remap ever - paste without losing register
  vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without losing register' })
  
  -- System clipboard yank
  vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
  vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system clipboard' })
  
  -- Delete to void register (don't affect clipboard)
  vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]], { desc = 'Delete to void register' })
''
