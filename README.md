# Dotfiles

Personal configuration files, including a Neovim setup that can be installed
automatically when provisioning an Applied devbox.

## Managing these files with yadm

On the laptop, yadm tracks files in your home directory. Make changes there
and use `yadm add`, `yadm commit`, and `yadm push` to publish them. A separate
Git clone has its own working files; edits there do not automatically update
yadm's files.

Track both `install-devbox.sh` and `.config/devbox/shell.sh` in yadm. The
installer uses the shell file from its own checkout. On devboxes, use a normal
clone and run the installer below to install only the portable configuration.
Do not run the Linux installer on the laptop.

## Automatic devbox setup

### 1. Make the installer available on GitHub

Merge the devbox setup changes into this repository's default branch (`main`)
before creating a new devbox. A local commit or an unmerged feature branch
alone will not make the installer available to the default clone.

### 2. Configure provisioning on your laptop

Add this entry to `~/.config/applied-devbox/config.toml` on the laptop used to
provision devboxes. Keep your existing configuration; if an entry for this
repo already exists, update it instead of adding a duplicate.

```toml
[[git.clone]]
repo = "git@github.com:brymon68/dot_files.git"
target_dest = "code/dot_files"
install_command = "install-devbox.sh"
```

- `repo` identifies the private GitHub repository.
- `target_dest` is relative to the devbox user's home directory, so this
  checkout lives at `~/code/dot_files` on the devbox.
- `install_command` is the executable script path relative to that checkout.
  The provisioning system runs it after the repositories have been cloned.

This laptop configuration is separate from the dotfiles repository. Cloning
this repo or running its installer does not add the provisioning entry for you.

### 3. Provision a devbox normally

With the configuration above, provisioning clones the repo and invokes
[`install-devbox.sh`](install-devbox.sh) on the new devbox. The installer
locates its own checkout, installs Neovim and its system dependencies, and
links the Neovim config. Your existing configuration handles plugin, Mason
tool, and syntax parser installation when you first launch Neovim.

Once provisioning completes, connect to the devbox and run:

```sh
nvim
```

Keep Neovim open while the first-run installs finish. Provisioning does not
wait for or verify those downloads.

The provisioning hook runs during setup; it is not an installer that runs on
every SSH login.

## Private repository access

The devbox must have GitHub SSH authentication for an account with read access
to `brymon68/dot_files` when the clone runs. The tested `dev0` could clone this
repo using `cyberoai`. A newly provisioned box using the same authentication
should have the same access; fresh-box provisioning has not yet been tested.

Read access is sufficient for provisioning. Collaborator write access is only
needed to push changes. The installer does not embed a token, copy a private
key, or configure GitHub authentication.

## What the installer sets up

The supported target is Ubuntu on Linux x86_64, tested on Ubuntu 24.04.

- Pinned, SHA-256-checked Neovim, Node.js/npm, Starship, and Tree-sitter CLI releases
  under `~/.local/opt`, with symlinks in `~/.local/bin`.
- Missing Ubuntu dependencies, including FZF, ripgrep, fd, a C compiler, Go, and
  Python venv support. This step requires noninteractive sudo.
- A symlink from `~/.config/nvim` to the checkout's `.config/nvim`, respecting
  XDG directory overrides.
- Your existing lazy.nvim, Mason, and Tree-sitter configuration handles
  plugins and tools at editor startup. The shell installer does not run
  Neovim headlessly or use a separate Lua bootstrap script.
- PATH and portable Bash/Zsh integration for Starship and Ctrl-F → Neovim. Platform shell settings
  are preserved, and files replaced by the installer are backed up.

The devbox installer installs the Neovim and portable shell setup, not the repository's macOS
desktop, AWS, Git, or full shell configuration. See [DEVBOX.md](DEVBOX.md) for
versions, optional tools, troubleshooting, and rollback details.

## Existing devboxes and updates

For a box that already has the provisioning checkout, rerun:

```sh
~/code/dot_files/install-devbox.sh
```

The initial experiment on `dev0` used `~/dot_files` instead, so its rerun
command is `~/dot_files/install-devbox.sh`.

The installer is safe to rerun: it retains completed tool installs, avoids
duplicate PATH entries, and rechecks system dependencies after an image
reset. It does not pull or reset the checkout. To adopt upstream changes,
update your checkout first, then rerun the installer.

If you run the installer from an already-open shell, start a fresh shell to load the prompt and key bindings:

```sh
exec "$SHELL"
```

For a box without this checkout, follow the manual setup in
[DEVBOX.md](DEVBOX.md). For failed tool downloads, inspect `:MasonLog` in
Neovim, fix the underlying issue, and restart Neovim to retry missing tools.

## Connecting from local tmux

Remote tmux stays enabled to preserve sessions across disconnections. The
installer enables remote mouse scrolling and uses Ctrl-B remotely, while the
laptop uses Ctrl-Space. See [DEVBOX.md](DEVBOX.md#local-tmux-and-devbox-ssh)
for scrolling, copy mode, and updating already-open shells.
