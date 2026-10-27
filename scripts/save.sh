#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
host_name="${1:-desktop}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"

case "$host_name" in
  desktop|laptop) ;;
  *) echo "Usage: $0 desktop|laptop" >&2; exit 2 ;;
esac

noctalia_settings="$state_dir/noctalia/settings.toml"
if [[ -f "$noctalia_settings" ]]; then
  cp -- "$noctalia_settings" "$repo_dir/home/$host_name/noctalia-settings.toml"
else
  echo "Noctalia settings not found: $noctalia_settings" >&2
fi

git -C "$repo_dir" add -u
git -C "$repo_dir" diff --cached --check
if git -C "$repo_dir" diff --cached --quiet; then
  echo "No changes to save."
  exit 0
fi

git -C "$repo_dir" diff --cached --stat
echo "Review all staged changes before publishing to the public repository."
git -C "$repo_dir" diff --cached
read -r -p "Commit and push these changes? [y/N] " answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Changes remain staged; nothing was pushed."
  exit 0
fi

git -C "$repo_dir" commit -m "Update $host_name NixOS and desktop settings"
git -C "$repo_dir" push
