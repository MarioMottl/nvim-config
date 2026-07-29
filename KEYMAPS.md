# Keymaps

Leader key: `Space`

## General

| Key | Mode | Description |
|-----|------|-------------|
| `p` / `P` | visual | Paste without clobbering register |
| `J` | visual | Move selection down |
| `K` | visual | Move selection up |
| `<leader>cw` | n | Toggle which-key popup for this session |

## Buffers

| Key | Mode | Description |
|-----|------|-------------|
| `<Tab>` | n | Next buffer |
| `<S-Tab>` | n | Prev buffer |
| `<leader>h` | n | Move buffer left |
| `<leader>l` | n | Move buffer right |
| `<leader>x` | n | Close buffer (keep split) |
| `<leader>bd` | n | Delete buffer (keep split) |
| `<leader>n` | n | New tab |

## Splits

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sv` | n | Split vertical |
| `<leader>sh` | n | Split horizontal |
| `<leader>se` | n | Equal splits |
| `<leader>sx` | n | Close split |
| `<C-Up>` | n | Taller |
| `<C-Down>` | n | Shorter |
| `<C-Left>` | n | Narrower |
| `<C-Right>` | n | Wider |

## Terminal

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tf` | n/t | Toggle floating terminal |
| `<leader>th` | n | Open horizontal terminal |
| `<leader>tv` | n | Open vertical terminal |
| `<Esc><Esc>` | terminal | Leave terminal mode |
| `<C-h/j/k/l>` | terminal | Move between windows |

## Scroll (neoscroll)

| Key | Mode | Description |
|-----|------|-------------|
| `<PageUp>` | n/v/x | Scroll up (animated) |
| `<PageDown>` | n/v/x | Scroll down (animated) |
| `<C-u>` | n/v/x | Half page up (animated) |
| `<C-d>` | n/v/x | Half page down (animated) |
| `<C-b>` | n/v/x | Full page up (animated) |
| `<C-f>` | n/v/x | Full page down (animated) |

## File Explorer (NvimTree)

| Key | Mode | Description |
|-----|------|-------------|
| `<S-e>` | n | Toggle NvimTree |
| `<leader>e` | n | Focus NvimTree |
| `<leader>ec` | n | Collapse all folders |

## Telescope

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | n | Find files |
| `<leader>fw` | n | Live grep |
| `<leader>fc` | n | Grep word under cursor |
| `<leader>fb` | n | Find buffers |
| `<leader>fk` | n | Find keymaps |
| `<C-t>` | Telescope | Open results in Trouble |

## Trouble

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>qD` | n | Workspace diagnostics |
| `<leader>qd` | n | Buffer diagnostics |
| `<leader>qq` | n | Quickfix list |
| `<leader>ql` | n | Location list |
| `<leader>qs` | n | Document symbols |

## Structural Editing

### Mini Surround

| Key | Mode | Description |
|-----|------|-------------|
| `sa` | n/x | Add surrounding |
| `sd` | n | Delete surrounding |
| `sr` | n | Replace surrounding |
| `sf` / `sF` | n | Find surrounding right/left |
| `sh` | n | Highlight surrounding |

### Treesitter Text Objects

| Key | Mode | Description |
|-----|------|-------------|
| `af` / `if` | x/o | Around/inside function |
| `ac` / `ic` | x/o | Around/inside class |
| `aa` / `ia` | x/o | Around/inside argument |
| `]m` / `[m` | n/x/o | Next/previous function |
| `]]` / `[[` | n/x/o | Next/previous class |
| `<leader>sn` | n | Swap with next argument |
| `<leader>sp` | n | Swap with previous argument |

## LSP (active when LSP attached)

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gR` | n | Show references |
| `gi` | n | Show implementations |
| `gt` | n | Show type definitions |
| `K` | n | Hover docs |
| `<leader>ca` | n/v | Show available code actions |
| `<leader>rn` | n | Rename symbol |
| `<leader>D` | n | Buffer diagnostics |
| `<leader>d` | n | Line diagnostics |
| `[d` | n | Prev diagnostic |
| `]d` | n | Next diagnostic |
| `<leader>rs` | n | Restart LSP |
| `<leader>ci` | n | Find callers of this function |
| `<leader>co` | n | Find functions called from here |
| `<leader>ch` | n | Find implementations |
| `<leader>cu` | n | Find references and usages |
| `<leader>ct` | n | Toggle diagnostics between save/live (persistent) |
| `<leader>cc` | n | Toggle completion popup (persistent; keeps LSP active) |
| `<leader>cL` | n | Toggle language servers globally (persistent) |

## Git (gitsigns)

| Key | Mode | Description |
|-----|------|-------------|
| `]h` | n | Next hunk |
| `[h` | n | Prev hunk |
| `<leader>gs` | n | Stage hunk |
| `<leader>gr` | n | Reset hunk |
| `<leader>gp` | n | Preview hunk |
| `<leader>gb` | n | Blame line |
| `<leader>gD` | n | Diff this |

## Search

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sq` | n | Send search pattern to quickfix |

## Theme

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ts` | n | Select theme (picker) |
| `<leader>tn` | n | Next theme |
| `<leader>tp` | n | Prev theme |

## Obsidian

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ob` | n | Backlinks |
| `<leader>od` | n | Daily note |
| `<leader>ol` | n | Note links |
| `<leader>oo` | n | Open in Obsidian |
| `<leader>oq` | n | Quick switch |
| `<leader>os` | n | Search notes |
| `<leader>ot` | n | Insert template |
| `<leader>oT` | n | Table of contents |
| `<leader>on` | n | New note |
