#!/usr/bin/env bash
# Ubuntu x86_64 devbox bootstrap. Run from an authenticated clone of this repo.
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
[[ $(uname -s) == Linux && $(uname -m) == x86_64 ]] || {
  echo 'This installer currently supports Linux x86_64 only.' >&2; exit 1;
}
export PATH="$HOME/.local/bin:$PATH"
config_home=${XDG_CONFIG_HOME:-$HOME/.config}
state_home=${XDG_STATE_HOME:-$HOME/.local/state}
cache_home=${XDG_CACHE_HOME:-$HOME/.cache}
mkdir -p "$HOME/.local/bin" "$HOME/.local/opt" "$config_home" "$state_home/dotfiles" "$cache_home/dotfiles"
exec 9>"$state_home/dotfiles/install.lock"
flock -n 9 || { echo 'Another installer is running.' >&2; exit 1; }
backup_dir="$state_home/dotfiles/backups/$(date +%Y%m%d-%H%M%S)-$$"
backup() {
  mkdir -p "$backup_dir"
  cp -a -- "$1" "$backup_dir/$2"
  echo "Backed up $1 to $backup_dir/$2"
}
link() {
  local source=$1 target=$2
  if [[ -L $target && $(readlink "$target") == "$source" ]]; then return; fi
  if [[ -e $target || -L $target ]]; then
    backup "$target" "$(basename "$target")"
    # Move rather than delete an existing config directory or file.
    mv -- "$target" "$backup_dir/$(basename "$target").original"
  fi
  ln -s -- "$source" "$target"
}
fetch() {
  local url=$1 sum=$2 target=$3
  if [[ ! -f $target ]] || ! echo "$sum  $target" | sha256sum --check --status; then
    curl --fail --location --retry 3 --connect-timeout 20 "$url" -o "$target.part"
    echo "$sum  $target.part" | sha256sum --check --status || { echo "Checksum mismatch: $url" >&2; exit 1; }
    mv "$target.part" "$target"
  fi
}

# System packages are the only sudo step. Rechecked after devbox image resets.
packages=(ca-certificates curl git build-essential unzip xz-utils ripgrep fd-find fzf tmux golang-go python3-venv)
missing=()
for package in "${packages[@]}"; do
  [[ $(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true) == 'install ok installed' ]] || missing+=("$package")
done
if ((${#missing[@]})); then
  sudo -n apt-get update
  sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::Lock::Timeout=300 install -y --no-install-recommends "${missing[@]}"
fi

# Pinned official release archives, checked against publisher SHA-256 digests.
nvim_version=0.12.5
nvim_dir="$HOME/.local/opt/nvim-$nvim_version"
if [[ ! -x $nvim_dir/bin/nvim ]]; then
  archive="$cache_home/dotfiles/nvim-$nvim_version.tar.gz"
  fetch "https://github.com/neovim/neovim/releases/download/v$nvim_version/nvim-linux-x86_64.tar.gz" bce0f56eda1f1b1db6eee8f4133d7a38813ea07933837dd1777411ca384c6875 "$archive"
  stage=$(mktemp -d "$HOME/.local/opt/.nvim.XXXXXX")
  tar -xzf "$archive" -C "$stage" --strip-components=1
  mv "$stage" "$nvim_dir"
fi
link "$nvim_dir/bin/nvim" "$HOME/.local/bin/nvim"

# Mason's npm packages require a newer Node than Ubuntu's preinstalled Node 18.
node_version=22.23.2
node_dir="$HOME/.local/opt/node-$node_version"
if [[ ! -x $node_dir/bin/node ]]; then
  archive="$cache_home/dotfiles/node-$node_version.tar.xz"
  fetch "https://nodejs.org/dist/v$node_version/node-v$node_version-linux-x64.tar.xz" d60acfe00a2932254bb0ad20e01b0d74397a0875595de719654b214f4b03f307 "$archive"
  stage=$(mktemp -d "$HOME/.local/opt/.node.XXXXXX")
  tar -xJf "$archive" -C "$stage" --strip-components=1
  mv "$stage" "$node_dir"
fi
for bin in node npm npx; do link "$node_dir/bin/$bin" "$HOME/.local/bin/$bin"; done

ts_version=0.26.6
ts_dir="$HOME/.local/opt/tree-sitter-$ts_version"
if [[ ! -x $ts_dir/tree-sitter ]]; then
  archive="$cache_home/dotfiles/tree-sitter-$ts_version.gz"
  fetch "https://github.com/tree-sitter/tree-sitter/releases/download/v$ts_version/tree-sitter-linux-x64.gz" 2b9595064a7d9dbe208c6f09f521d73061f8039e4ffcc2fd08979d249aeabb54 "$archive"
  mkdir -p "$ts_dir"
  gzip -dc "$archive" > "$ts_dir/tree-sitter.part"
  chmod +x "$ts_dir/tree-sitter.part"
  mv "$ts_dir/tree-sitter.part" "$ts_dir/tree-sitter"
fi
link "$ts_dir/tree-sitter" "$HOME/.local/bin/tree-sitter"
if ! command -v fd >/dev/null; then link "$(command -v fdfind)" "$HOME/.local/bin/fd"; fi
link "$repo/.config/nvim" "$config_home/nvim"

starship_version=1.26.0
starship_dir="$HOME/.local/opt/starship-$starship_version"
if [[ ! -x $starship_dir/starship ]]; then
  archive="$cache_home/dotfiles/starship-$starship_version.tar.gz"
  fetch "https://github.com/starship/starship/releases/download/v$starship_version/starship-x86_64-unknown-linux-musl.tar.gz" b7c232b0e8249d8e55a40beb79c5c43a7d370f3f9408bd215deb0170daeaadf3 "$archive"
  stage=$(mktemp -d "$HOME/.local/opt/.starship.XXXXXX")
  tar -xzf "$archive" -C "$stage"
  mv "$stage" "$starship_dir"
fi
link "$starship_dir/starship" "$HOME/.local/bin/starship"
link "$repo/.config/starship.toml" "$config_home/starship.toml"
link "$repo/.config/devbox" "$config_home/devbox"

# Extend the active remote tmux config without replacing platform settings.
tmux_rc="$HOME/.tmux.conf"
if [[ ! -e $tmux_rc && -e $config_home/tmux/tmux.conf ]]; then
  tmux_rc="$config_home/tmux/tmux.conf"
fi
tmux_line="source-file \"$config_home/devbox/tmux.conf\" # dotfiles-devbox-tmux"
if ! grep -Fqx "$tmux_line" "$tmux_rc" 2>/dev/null; then
  [[ ! -e $tmux_rc ]] || backup "$tmux_rc" tmux.conf
  printf '\n%s\n' "$tmux_line" >> "$tmux_rc"
fi

# Preserve platform startup; source only the portable devbox shell additions.
path_line='export PATH="$HOME/.local/bin:$PATH" # dotfiles-devbox'
for rc in "$HOME/.profile" "$HOME/.bashrc" "${ZDOTDIR:-$HOME}/.zshrc"; do
  if ! grep -Fqx "$path_line" "$rc" 2>/dev/null; then
    [[ ! -e $rc ]] || backup "$rc" "$(basename "$rc")"
    printf '\n%s\n' "$path_line" >> "$rc"
  fi
done
shell_line='[ ! -r "${XDG_CONFIG_HOME:-$HOME/.config}/devbox/shell.sh" ] || . "${XDG_CONFIG_HOME:-$HOME/.config}/devbox/shell.sh" # dotfiles-devbox-shell'
for rc in "$HOME/.bashrc" "${ZDOTDIR:-$HOME}/.zshrc"; do
  if ! grep -Fqx "$shell_line" "$rc" 2>/dev/null; then
    # Preserve the pre-install backup if PATH was also added in this run.
    [[ ! -e $rc || -e $backup_dir/$(basename "$rc") ]] || backup "$rc" "$(basename "$rc")"
    printf '\n%s\n' "$shell_line" >> "$rc"
  fi
done

echo 'Ready. Open a new shell to enable Starship and Ctrl-F (files → Neovim).'
echo 'Start nvim and let your existing plugin configuration finish its first-run installs.'
nvim --version | head -1
