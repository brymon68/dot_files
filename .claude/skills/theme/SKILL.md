---
name: theme
description: Apply a terminal color theme across ghostty, neovim, bat, fzf and tmux from a Ghostty color palette. Use when the user wants to set, change, or switch their terminal theme/colorscheme, e.g. "set my dark theme to black metal", "make my light theme rose-pine".
---

# theme

Applies a Ghostty color palette to five tools at once — **ghostty, neovim, bat,
fzf, tmux**. Each tool keeps an independent **dark slot** and **light slot**
that auto-switch with macOS appearance.

All five configs are managed by **yadm**. The skill never commits.

## Two modes

- **setup** — one-time refactor of the configs. Required before first use.
- **apply** — theme one slot (dark or light). Normal use.

Decide which: if `~/.config/theme/state.json` is **missing**, setup must run
first. If the user asks to theme something and state is missing, tell them
setup will run first and confirm.

`SKILL_DIR` below = the directory containing this file
(`~/.claude/skills/theme`).

---

## Apply (normal use)

User says e.g. *"set my **dark** theme to **black metal**"*.

1. **The slot is required.** If the user did not say `dark` or `light`,
   ask which slot — never guess. A theme being dark-looking does not mean
   the dark slot is intended.
2. **Resolve the theme by name:**
   - Run `ghostty +list-themes --plain` and match against the requested name.
   - Exactly one match → its file is
     `/Applications/Ghostty.app/Contents/Resources/ghostty/themes/<Name>`.
   - Multiple matches (e.g. *"Black Metal"* has variants like
     *Black Metal (Bathory)*) → list them and ask which.
   - No match → web-fetch `https://ghostty-style.vercel.app/config/<slug>`,
     extract the palette, write a Ghostty theme file to
     `~/.config/ghostty/themes/<slug>` (lines: `palette = N=#hex` for 0–15,
     plus `background`, `foreground`, and `cursor-color` /
     `selection-background` if given). Use that path and `<slug>` as the name.
3. **Apply:**
   ```
   python3 SKILL_DIR/scripts/theme.py apply \
     --slot <dark|light> --theme-file "<path>" --name "<Name>"
   ```
4. **Report** (see *Reporting* below).

---

## Setup (one-time)

Only when `~/.config/theme/state.json` is absent. **Confirm with the user
first** — it rewrites hand-written config files. All targets are yadm-tracked,
so `yadm diff` / `yadm checkout` can undo anything.

1. **nvim colorscheme layer** — overwrite both files:
   - `SKILL_DIR/templates/nvim-colorscheme.lua` → `~/.config/nvim/lua/plugins/colorscheme.lua`
   - `SKILL_DIR/templates/nvim-windline.lua` → `~/.config/nvim/lua/plugins/windline.lua`

   These add `RRethy/base16-nvim` as a dependency and make each light/dark
   branch use base16 when that slot is skill-themed, else fall back to
   catppuccin/dawnfox.
2. **Install the plugin:** `nvim --headless "+Lazy! install" +qa`
   (`install`, not `sync` — only fetch missing plugins, don't update others)
3. **tmux** — in `~/.config/tmux/tmux.conf`, replace the macOS dark-mode status
   block (from the `# Check for dark mode` comment through the end of the
   *second* `if-shell`) with a single line, kept **before** the
   `run '.../tpm/tpm'` line:
   ```
   source-file ~/.config/tmux/theme.conf
   ```
4. **fzf** — in `~/.zshrc` there are two `FZF_DEFAULT_OPTS` exports. Keep the
   first (static opts: layout/height/bind). **Delete the second** (the
   multi-line one with hardcoded `--color`). Immediately after the first
   export, insert:
   ```sh
   # theme skill: source generated fzf colors for current macOS appearance
   if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
     [ -f "$HOME/.config/fzf/theme-dark.zsh" ] && source "$HOME/.config/fzf/theme-dark.zsh"
   else
     [ -f "$HOME/.config/fzf/theme-light.zsh" ] && source "$HOME/.config/fzf/theme-light.zsh"
   fi
   ```
5. **bat** — in `~/.config/bat/config`, replace the `--theme="..."` line with:
   ```
   --theme-dark="theme-dark"
   --theme-light="theme-light"
   ```
6. **Seed state + generate everything:** `python3 SKILL_DIR/scripts/theme.py init`
   — this reads Ghostty's current `theme =` line, seeds both slots from those
   palettes (neither marked nvim-themed, so nvim keeps catppuccin/dawnfox until
   explicitly themed), writes all generated files, and runs `bat cache --build`.
7. **Report** (see *Reporting* below).

---

## Reporting (after setup or apply)

1. Run `yadm diff --stat` and show it.
2. Suggest, do **not** run: `yadm commit -am "theme(<slot>): <name>"`.
3. Print the reload checklist:
   - **Ghostty** — reload config (⌘⇧,)
   - **nvim** — restart (running instances keep the old theme)
   - **shells** — open a new shell (fzf reads macOS appearance at shell init,
     so a mid-session OS light/dark switch won't reach fzf until then)
   - **tmux** — `tmux source-file ~/.config/tmux/tmux.conf`

   `bat` needs nothing — `theme.py` already ran `bat cache --build`.

---

## How it works

`scripts/theme.py` holds `~/.config/theme/state.json` (both slots' 16-color
base16 palettes + names) as the single source of truth, and regenerates every
output file from it on each run:

| Tool | Generated | base16 derivation |
|------|-----------|-------------------|
| ghostty | `theme =` line in `ghostty/config` | name reference only |
| nvim | `nvim/lua/config/theme.lua` | full base16 palette |
| bat | `bat/themes/theme-{dark,light}.tmTheme` | tmTheme scopes |
| fzf | `fzf/theme-{dark,light}.zsh` | `--color` block (bg stays transparent) |
| tmux | `tmux/theme.conf` | status-bar colors |

base16 is derived from a Ghostty theme's 16-color ANSI palette — ~10 colors
map directly, the 6 in-between shades are interpolated. See the `theme.py`
header for the full mapping.

`theme.py` subcommands: `init`, `apply`, `generate`, `show`. Run
`python3 SKILL_DIR/scripts/theme.py show` to see the current dark/light themes.
