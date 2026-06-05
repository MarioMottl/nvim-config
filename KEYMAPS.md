# Keymaps

Leader key: `Space`

## General

| Key | Mode | Description |
|-----|------|-------------|
| `p` / `P` | visual | Paste without clobbering register |
| `J` | visual | Move selection down |
| `K` | visual | Move selection up |

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

## LSP (active when LSP attached)

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gR` | n | Show references |
| `gi` | n | Show implementations |
| `gt` | n | Show type definitions |
| `K` | n | Hover docs |
| `<leader>ca` | n/v | Code actions |
| `<leader>rn` | n | Rename symbol |
| `<leader>D` | n | Buffer diagnostics |
| `<leader>d` | n | Line diagnostics |
| `[d` | n | Prev diagnostic |
| `]d` | n | Next diagnostic |
| `<leader>rs` | n | Restart LSP |
| `<leader>ci` | n | LSP incoming calls |
| `<leader>co` | n | LSP outgoing calls |
| `<leader>ch` | n | LSP implementations |
| `<leader>cu` | n | LSP references |
| `<leader>ct` | n | Toggle diagnostics on save |
| `<leader>cL` | n | Toggle LSP on/off |

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
