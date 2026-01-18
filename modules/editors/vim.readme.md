# Vim Configuration Documentation

## Plugins Overview

### Theme & UI
- **tokyonight-vim** - Tokyo Night color scheme (fetched from GitHub)
  - Night style with transparency enabled
- **lightline-vim** - Lightweight and fast statusline
- **vim-web-devicons** - File type icons (requires a Nerd Font)

### File Navigation & Search
- **fzf-vim** - Fuzzy file finder and text search
  - Integrated with ripgrep for fast text searching
  - Preview windows powered by `bat` for syntax-highlighted previews
- **vim-startify** - Start screen with recently used files (Harpoon alternative)
  - Quick access to recent files and bookmarks
  - Session management

### Language Support & LSP
- **vim-lsp** - Language Server Protocol client for Vim
- **vim-lsp-settings** - Automatic LSP server configuration
- **vim-terraform** - Terraform syntax and formatting
- **vim-go** - Go language support
- **typescript-vim** - TypeScript syntax support
- **vim-javascript** - JavaScript syntax support

### Autocompletion
- **asyncomplete-vim** - Asynchronous completion framework
- **asyncomplete-lsp-vim** - LSP completion source for asyncomplete

### Utilities
- **vim-commentary** - Easy commenting with `gc` motions
- **vim-surround** - Manipulate surrounding quotes, brackets, tags
- **vim-repeat** - Repeat plugin commands with `.`
- **auto-pairs** - Automatic closing of brackets, quotes, etc.
- **vim-gitgutter** - Git diff indicators in the sign column

## External Tools

These are installed via `home.packages` and used by Vim:

- **fzf** - Fuzzy finder engine
- **ripgrep** - Fast text search tool (used by `:Rg`)
- **fd** - Fast file finder (used by FZF)
- **bat** - Syntax-highlighted file previews in FZF
- **prettier** - Code formatter

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

## FZF (File & Text Search)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find files | Search for files in current directory |
| `<leader>fo` | File history | Search recently opened files |
| `<leader>rg` | Ripgrep | Search for text across all files |
| `<leader>fb` | Find buffers | List and switch between open buffers |
| `<leader>fh` | Help tags | Search Vim help documentation |

### FZF Preview Controls (while in FZF)
| Key | Action | Description |
|-----|--------|-------------|
| `<Ctrl-/>` | Toggle preview | Show/hide preview window |
| `<Ctrl-u>` | Preview up | Scroll preview up |
| `<Ctrl-d>` | Preview down | Scroll preview down |

---

## Startify (Quick File Access)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>s` | Open Startify | Show start screen with recent files |

**Startify Lists:**
- Recent files in any directory
- Recent files in current directory
- Saved sessions
- Bookmarks

**Predefined Bookmarks:**
- `c` - `~/.config`
- `n` - `~/.config/nixos`

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
| `<leader>f` | Format | Format current file with LSP |
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |

---

## Completion (Insert Mode)

| Key | Action | Description |
|-----|--------|-------------|
| `<Tab>` | Next item | Select next completion item |
| `<Shift-Tab>` | Previous item | Select previous completion item |
| `<Enter>` | Confirm | Accept selected completion |

Completion automatically appears as you type. LSP-powered suggestions include:
- Functions and methods
- Variables and constants
- Types and interfaces
- File paths
- Buffer text

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

## Comments (vim-commentary)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `gc` | Normal/Visual | Toggle comment | Comment/uncomment line or selection |
| `gcc` | Normal | Toggle line comment | Comment/uncomment current line |
| `gc` + motion | Normal | Comment motion | e.g., `gcap` comments a paragraph |

---

## Surround (vim-surround)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `cs"'` | Normal | Change surround | Change `"` to `'` around text |
| `ds"` | Normal | Delete surround | Remove surrounding `"` |
| `ysiw"` | Normal | Add surround | Surround inner word with `"` |
| `S"` | Visual | Surround selection | Wrap visual selection with `"` |

**Examples:**
- `cs"'` - Change `"hello"` to `'hello'`
- `ds(` - Delete `(hello)` to `hello`
- `ysiw]` - Change `hello` to `[hello]`
- `yss}` - Wrap entire line with `{}`

---

## Git (vim-gitgutter)

Git changes are automatically shown in the sign column:
- `+` Added lines
- `~` Modified lines
- `-` Deleted lines
- `^` Removed first line
- `~` Modified and removed

---

## Editor Settings

### Appearance
- Line numbers with relative numbering
- Transparent background for terminal opacity
- Sign column always visible
- Tokyo Night color scheme (night style)

### Indentation
- 2 spaces for: JavaScript, TypeScript, JSON, YAML, Terraform
- 4 spaces for: Go, Python
- Tab key inserts spaces (expandtab)

### Search
- Case-insensitive search
- Smart case (case-sensitive if search contains uppercase)
- No persistent search highlighting

### Auto-formatting
Files are automatically formatted on save for:
- Go (`.go`)
- Terraform (`.tf`, `.terraform`)
- JavaScript/TypeScript (`.js`, `.jsx`, `.ts`, `.tsx`)
- JSON, YAML (`.json`, `.yaml`, `.yml`)

---

## Installed LSP Servers

All LSP servers are automatically registered and started:

- **typescript-language-server** - TypeScript/JavaScript
  - Triggers on: `.ts`, `.tsx`, `.js`, `.jsx`
- **gopls** - Go
  - Triggers on: `.go`, `.mod`
- **terraform-ls** - Terraform
  - Triggers on: `.tf`, `.terraform`
- **yaml-language-server** - YAML
  - Triggers on: `.yaml`, `.yml`
  - Includes Kubernetes schemas
- **vscode-json-language-server** - JSON
  - Triggers on: `.json`, `.jsonc`

---

## Tips & Workflow

### File Navigation with FZF
1. **Find files**: Press `<leader>ff` and start typing filename
2. **Search text**: Press `<leader>rg` and enter search term
3. **Recent files**: Press `<leader>fo` to see file history
4. **Preview**: Use `Ctrl-/` to toggle preview while in FZF

### Quick File Access with Startify
1. Launch Vim without arguments to see Startify screen
2. Use number keys to quickly open recent files
3. Press `<leader>s` anytime to return to Startify
4. Sessions auto-save and can be restored

### LSP Workflow
1. **Hover** over symbols with `K` to see documentation
2. **Jump to definition** with `gd`
3. **Find all usages** with `gr`
4. **Rename refactoring** with `<leader>rn`
5. **Code fixes** with `<leader>ca`

### Text Editing
1. Use **vim-surround** to quickly change quotes/brackets
2. **Comment blocks** with `gc` + visual selection
3. **Auto-pairs** automatically closes brackets as you type
4. Use **`.`** to repeat surround/comment operations

### Git Integration
- Git changes show in sign column automatically
- Use with `:Git` commands (if vim-fugitive is added)

---

## Configuration File Location

This configuration is managed by Home Manager and is read-only at:
- Vim config: `/nix/store/.../vimrc`

To modify:
1. Edit: `~/nixos-dotfiles/modules/vim.nix`
2. Rebuild: `home-manager switch` or `sudo nixos-rebuild switch`

---

## Troubleshooting

### LSP not working
- Check if LSP server is installed: `:LspStatus`
- Verify file type: `:set filetype?`
- See LSP logs: `:LspLog`

### FZF not finding files
- Ensure ripgrep is installed: `rg --version`
- Check FZF is available: `fzf --version`

### Completion not appearing
- Verify LSP is attached: `:LspStatus`
- Check asyncomplete: `:AsyncompleteInfo`

### Theme not loading
- Ensure terminal supports true colors
- Check colorscheme: `:colorscheme`
