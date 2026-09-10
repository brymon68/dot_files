# Neovim on a devbox

Test target: Ubuntu 24.04, Linux x86_64 (`dev0`). This installs the existing
Neovim configuration from this repo, including its plugin lockfile.

## First setup

Use the devbox's configured SSH access to GitHub. The repository is private;
the installer does not store a token or copy your private key.

```sh
git clone git@github.com:brymon68/dot_files.git ~/dot_files
cd ~/dot_files
./install-devbox.sh
export PATH="$HOME/.local/bin:$PATH"
nvim
```

Noninteractive sudo is required if Ubuntu prerequisites are missing. Downloads
need access to GitHub release assets, nodejs.org, Ubuntu repositories, and the
package registries used by Mason (npm, PyPI, and Go).

## Rerunning and devbox provisioning

```sh
~/dot_files/install-devbox.sh
```

Use this command as the dotfiles install hook in your devbox provisioning
configuration, with the path adjusted to its checkout location. Run it again
after a devbox image reset: home-directory installs persist, but apt packages
may need reinstalling. The script does not pull or reset your Git checkout.
Update your checkout deliberately before rerunning when you want new config.

## What is installed

- Neovim 0.12.5, Node.js 22.23.2 (with npm/npx), and Tree-sitter CLI 0.26.6
  under `~/.local/opt`, with launcher symlinks in `~/.local/bin`. Official
  archives have pinned SHA-256 checksums.
- Missing Ubuntu prerequisites, including ripgrep, fd, a C compiler, Go,
  and Python venv support. Ubuntu package versions follow the image's repos.
- A link from `~/.config/nvim` to this checkout's `.config/nvim` (XDG paths
  are respected).
- Plugins restored to `lazy-lock.json`; all 18 configured Tree-sitter parsers.
- The ten tools listed in `lua/plugins/mason.lua`, including Python, Lua, Go,
  and TypeScript language servers, formatters, and linters. Mason versions
  are resolved on first install; existing installed tools are retained.

The script preserves platform shell startup and adds one PATH line to
`.profile`, `.bashrc`, and `.zshrc`. It does not install the macOS shell,
desktop, AWS, or Git configuration. Node in `~/.local/bin` takes precedence
over system Node once the PATH line is loaded.

`DOTFILES_BOOTSTRAP` disables the normal asynchronous Mason and parser
auto-installs only during setup. The installer waits for them explicitly,
checks the results, and exits nonzero on failure. Normal Neovim behavior is
unchanged when this variable is absent.

## Troubleshooting

- `:MasonLog`: dependency download/build failures. Fix connectivity or package
  availability and rerun; completed installs are retained.
- `:checkhealth`: editor/plugin health. A Nerd Font should be selected in the
  terminal on your laptop for the configured icons.
- The config's optional Groovy formatter (`npm-groovy-lint`) and Go linter
  (`golangci-lint`) are not in its Mason install list; install these separately
  if you use those features. Browser previews also need a suitable remote
  browser/port-forwarding workflow.
- Python environment and monorepo indexing settings remain your existing
  config; select the appropriate project environment when editing.

## Backups and rollback

Replaced files and pre-edit shell files are backed up under
`~/.local/state/dotfiles/backups/<timestamp>-<pid>/` (or `$XDG_STATE_HOME`).
The installer prints the exact paths. To roll back, remove the new symlink
and restore its corresponding `.original` backup. Remove the line marked
`# dotfiles-devbox` from the shell files to undo PATH integration. Installed
apt dependencies are retained; old versioned binaries are never deleted.
