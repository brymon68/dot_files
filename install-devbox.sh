#!/usr/bin/env bash
# Ubuntu x86_64 devbox bootstrap. Run from an authenticated clone of this repo.
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
[[ $(uname -s) == Linux && $(uname -m) == x86_64 ]] || {
  echo 'This installer currently supports Linux x86_64 only.' >&2; exit 1;
}
export PATH="$HOME/.local/bin:$PATH"
config_home=${XDG_CONFIG_HOME:-$HOME/.config}
data_home=${XDG_DATA_HOME:-$HOME/.local/share}
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
packages=(ca-certificates curl git build-essential unzip xz-utils ripgrep fd-find golang-go python3-venv)
missing=()
for package in "${packages[@]}"; do
  [[ $(dpkg-query -W -f='${Status}' "$package" 2>/dev/null || true) == 'install ok installed' ]] || missing+=("$package")
done
if ((${#missing[@]})); then
  sudo -n apt-get update
  sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${missing[@]}"
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

# Keep the platform shell config and add only PATH. Never source the macOS zshrc.
path_line='export PATH="$HOME/.local/bin:$PATH" # dotfiles-devbox'
for rc in "$HOME/.profile" "$HOME/.bashrc" "${ZDOTDIR:-$HOME}/.zshrc"; do
  if ! grep -Fqx "$path_line" "$rc" 2>/dev/null; then
    [[ ! -e $rc ]] || backup "$rc" "$(basename "$rc")"
    printf '\n%s\n' "$path_line" >> "$rc"
  fi
done

# Bootstrap lazy.nvim at the commit recorded by this repo, not today's stable tip.
lazy_dir="$data_home/nvim/lazy/lazy.nvim"
lazy_commit=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["lazy.nvim"]["commit"])' "$repo/.config/nvim/lazy-lock.json")
if [[ ! -d $lazy_dir ]]; then
  mkdir -p "$(dirname "$lazy_dir")"
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$lazy_dir"
  git -C "$lazy_dir" checkout "$lazy_commit"
fi
export DOTFILES_BOOTSTRAP=1
# Lazy may rewrite branch metadata; keep the user's lockfile byte-for-byte.
lock_backup=$(mktemp "$cache_home/dotfiles/lazy-lock.XXXXXX")
cp "$repo/.config/nvim/lazy-lock.json" "$lock_backup"
trap 'cp "$lock_backup" "$repo/.config/nvim/lazy-lock.json"; rm -f "$lock_backup"' EXIT
nvim --headless '+Lazy! restore' +qa
cp "$lock_backup" "$repo/.config/nvim/lazy-lock.json"
export DOTFILES_REPO="$repo"
nvim --headless -l "$repo/scripts/bootstrap-nvim.lua"
echo 'Ready. In your current shell run: export PATH="$HOME/.local/bin:$PATH"'
nvim --version | head -1
