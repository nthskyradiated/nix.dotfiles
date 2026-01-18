# Neovim Configuration Documentation

## Plugins Overview

### Theme & UI
- **tokyonight-nvim** - Tokyo Night color scheme with storm variant
- **lualine-nvim** - Minimal and fast statusline at the bottom of the editor
- **nvim-web-devicons** - File type icons for various UI elements
- **which-key-nvim** - Displays available keybindings in a popup as you type

### File Navigation & Search
- **telescope-nvim** - Fuzzy finder for files, text, buffers, and more
- **telescope-fzf-native-nvim** - FZF sorter for telescope (faster sorting)
- **plenary-nvim** - Lua utility functions (required by telescope)
- **harpoon2** - Quick file navigation - mark files and jump between them instantly

### Language Support
- **nvim-treesitter** - Advanced syntax highlighting and code understanding
  - Supports: TypeScript, JavaScript, TSX, Go, Terraform, JSON, YAML, Lua, Vim, Markdown
- **nvim-lspconfig** - Configuration for Language Server Protocol (LSP)
  - Provides: code completion, go-to-definition, diagnostics, formatting
  - Configured for: TypeScript/JavaScript, Go, Terraform, JSON, YAML

### Autocompletion
- **nvim-cmp** - Completion engine
- **cmp-nvim-lsp** - LSP completion source
- **cmp-buffer** - Buffer text completion
- **cmp-path** - File path completion
- **cmp-cmdline** - Command-line completion
- **luasnip** - Snippet engine
- **cmp_luasnip** - Snippet completion source

### Utilities
- **zen-mode-nvim** - Distraction-free coding mode
- **gitsigns-nvim** - Git integration (shows added/modified/deleted lines in the gutter)
- **comment-nvim** - Smart commenting with `gc` motions

## Keybindings Reference

### Leader Key
**Space** (` `) - All custom keybindings start with the leader key

---

## General Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>w` | Save | Write current buffer |
| `<leader>q` | Quit | Quit current window |
| `<leader>cd` | Explorer | Open file explorer (`:Ex`) |
| `<leader>h` | Clear search | Remove search highlighting |

---

## Telescope (File & Text Search)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find files | Search for files in current directory |
| `<leader>fg` | Live grep | Search for text across all files |
| `<leader>fb` | Find buffers | List and switch between open buffers |
| `<leader>fh` | Help tags | Search Neovim help documentation |
| `<leader>fs` | Document symbols | Search symbols in current file (functions, variables, etc.) |

---

## Harpoon (Quick File Navigation)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>a` | Add file | Mark current file in Harpoon |
| `<Ctrl-e>` | Toggle menu | Open Harpoon quick menu |
| `<Ctrl-h>` | Jump to file 1 | Jump to first marked file |
| `<Ctrl-j>` | Jump to file 2 | Jump to second marked file |
| `<Ctrl-k>` | Jump to file 3 | Jump to third marked file |
| `<Ctrl-l>` | Jump to file 4 | Jump to fourth marked file |

---

## LSP (Language Server Protocol)

| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to definition | Jump to where symbol is defined |
| `K` | Hover | Show documentation for symbol under cursor |
| `gi` | Go to implementation | Jump to implementation |
| `gr` | References | Find all references to symbol |
| `<leader>rn` | Rename | Rename symbol across project |
| `<leader>ca` | Code action | Show available code actions |
| `<leader>f` | Format | Format current file |
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |

---

## Completion (Insert Mode)

| Key | Action | Description |
|-----|--------|-------------|
| `<Ctrl-Space>` | Trigger completion | Manually trigger completion menu |
| `<Tab>` | Next item | Select next completion item |
| `<Shift-Tab>` | Previous item | Select previous completion item |
| `<Enter>` | Confirm | Accept selected completion |
| `<Ctrl-d>` | Scroll docs down | Scroll completion documentation down |
| `<Ctrl-f>` | Scroll docs up | Scroll completion documentation up |

---

## Window Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `<Ctrl-Left>` | Move left | Focus window to the left |
| `<Ctrl-Down>` | Move down | Focus window below |
| `<Ctrl-Up>` | Move up | Focus window above |
| `<Ctrl-Right>` | Move right | Focus window to the right |

---

## Text Editing

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<` | Visual | Unindent | Decrease indentation (stays in visual mode) |
| `>` | Visual | Indent | Increase indentation (stays in visual mode) |
| `<Alt-j>` | Normal | Move line down | Move current line down |
| `<Alt-k>` | Normal | Move line up | Move current line up |
| `<Alt-j>` | Visual | Move lines down | Move selected lines down |
| `<Alt-k>` | Visual | Move lines up | Move selected lines up |

---

## Zen Mode

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>z` | Toggle Zen Mode | Enter/exit distraction-free mode |

---

## Git (Gitsigns)

Git changes are automatically shown in the sign column:
- `+` Added lines
- `~` Modified lines
- `-` Deleted lines

---

## Comments

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `gc` | Normal/Visual | Toggle comment | Comment/uncomment line or selection |
| `gcc` | Normal | Toggle line comment | Comment/uncomment current line |

---

## Tips

1. **Harpoon Workflow**: Mark your most-used files with `<leader>a`, then quickly jump between them with `Ctrl-h/j/k/l`
2. **Telescope Preview**: Use `Ctrl-/` to toggle preview window in telescope
3. **LSP Diagnostics**: Hover over errors/warnings to see details with `K`
4. **Which-key**: Press `<leader>` and wait a moment to see available keybindings
5. **Format on Save**: Files are automatically formatted when you save (`:w`)

---

## Installed LSP Servers

- **ts_ls** - TypeScript/JavaScript
- **gopls** - Go
- **terraformls** - Terraform
- **jsonls** - JSON
- **yamlls** - YAML (with Kubernetes schemas)

All LSP servers are automatically started when you open relevant file types.
