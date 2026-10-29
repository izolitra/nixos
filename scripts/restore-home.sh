#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
host_name="${1:-desktop}"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
backup_dir="$state_dir/nixos-config-backups/$(date +%Y%m%d-%H%M%S)"

case "$host_name" in
  desktop|laptop) ;;
  *) echo "Usage: $0 desktop|laptop" >&2; exit 2 ;;
esac

install_config() {
  local source_file="$1" target_file="$2" backup_name="$3"
  if [[ -e "$target_file" || -L "$target_file" ]]; then
    mkdir -p -- "$backup_dir"
    cp -a -- "$target_file" "$backup_dir/$backup_name"
  fi
  install -Dm0644 -- "$source_file" "$target_file"
}

install_config "$repo_dir/home/hyprland.lua" "$config_dir/hypr/hyprland.lua" hyprland.lua
install_config "$repo_dir/home/ghostty-config.ghostty" "$config_dir/ghostty/config.ghostty" ghostty-config.ghostty
install_config "$repo_dir/home/fastfetch-config.jsonc" "$config_dir/fastfetch/config.jsonc" fastfetch-config.jsonc
if [[ ! -e "$HOME/.bashrc" && ! -L "$HOME/.bashrc" ]]; then
  install_config "$repo_dir/home/bashrc-fastfetch" "$HOME/.bashrc" bashrc
else
  echo "Keeping existing ~/.bashrc; add 'fastfetch' there manually if desired."
fi
install_config "$repo_dir/home/$host_name/noctalia-settings.toml" "$state_dir/noctalia/settings.toml" noctalia-settings.toml
install_config "$repo_dir/home/noctalia-layout.toml" "$config_dir/noctalia/layout.toml" noctalia-layout.toml
install_config "$repo_dir/home/noctalia-shell.service" "$config_dir/systemd/user/noctalia-shell.service" noctalia-shell.service
install_config "$repo_dir/home/waybar-config.jsonc" "$config_dir/waybar/config.jsonc" waybar-config.jsonc
install_config "$repo_dir/home/waybar-style.css" "$config_dir/waybar/style.css" waybar-style.css

systemctl --user daemon-reload
systemctl --user enable noctalia-shell.service

echo "User settings restored. Previous files, if any, are in $backup_dir"
echo "Log out and back in to load the Hyprland configuration and Noctalia service."
