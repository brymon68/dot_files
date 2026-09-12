# Shell and Neovim on a devbox

Test target: Ubuntu 24.04, Linux x86_64 (`dev0`). This installs the existing
Neovim configuration from this repo, including its plugin lockfile.

## First setup

Use the devbox's configured SSH access to GitHub. The repository is private;
the installer does not store a token or copy your private key.

```sh
git clone git@github.com:brymon68/dot_files.git ~/dot_files
cd ~/dot_files
./install-devbox.sh
exec "$SHELL"
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

- Neovim 0.12.5, Node.js 22.23.2 (with npm/npx), Starship 1.26.0,
  and Tree-sitter CLI 0.26.6
  under `~/.local/opt`, with launcher symlinks in `~/.local/bin`. Official
  archives have pinned SHA-256 checksums.
- Missing Ubuntu prerequisites, including FZF, ripgrep, fd, a C compiler, Go,
  and Python venv support. Ubuntu package versions follow the image's repos.
- A link from `~/.config/nvim` to this checkout's `.config/nvim` (XDG paths
  are respected).

On first launch, your existing Neovim configuration installs plugins, its
18 configured Tree-sitter parsers, and the ten tools listed in
`lua/plugins/mason.lua`. These include Python, Lua, Go, and TypeScript language
servers, formatters, and linters. Mason versions are resolved on first install;
existing installed tools are retained. Keep Neovim open until downloads finish.

The script preserves platform shell startup, adds PATH to `.profile`,
`.bashrc`, and `.zshrc`, and sources `.config/devbox/shell.sh` from Bash and
Zsh. Interactive shells enable Starship using this repo's configuration and
bind **Ctrl-F** to select a file and open it in Neovim. The `ff` command works
too. In Git repositories it searches tracked files; **Ctrl-U** expands the
search to non-ignored files. Escape cancels without opening anything.
FZF's packaged history and file bindings are also loaded.

It does not install the macOS shell, desktop, AWS, or Git configuration.
Node in `~/.local/bin` takes precedence over system Node.

The shell installer only sets up binaries, dependencies, configuration links,
and shell integration. It does not run Neovim headlessly, wait for plugin tools or parsers,
or use a separate Lua bootstrap script. Plugin installation failures are
reported inside Neovim rather than as provisioning failures.

## Troubleshooting

- `:MasonLog`: dependency download/build failures. Fix connectivity or package
  availability and restart Neovim; completed installs are retained.
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
and restore its corresponding `.original` backup. Remove the lines marked
`# dotfiles-devbox` and `# dotfiles-devbox-shell` from the shell files to undo
PATH and shell integration. Installed
apt dependencies are retained; old versioned binaries are never deleted.

## Local tmux and devbox SSH

The laptop `.zshrc` wraps `dbox ssh`: when `$TMUX` is set, it adds
`--no-tmux`, so the local tmux owns scrolling and pane management. Outside
local tmux, dbox keeps its default remote tmux behavior. Load the updated
laptop `.zshrc` before using this wrapper. For an immediate workaround:

```sh
dbox ssh dev0 --no-tmux
```

Use `dbox ssh dev0 --session work` or `dbox ssh dev0 --no-tmux=false` to
explicitly request remote tmux, or `command dbox ssh dev0` to bypass the
wrapper. Global flags placed before `ssh` also bypass the wrapper; add
`--no-tmux` yourself in that form.

Without remote tmux, remote foreground work is not protected against SSH
connection loss. For long-running jobs, explicitly use a remote session;
connecting from a terminal outside local tmux avoids nesting in that case.
