# NixOS configuration

[Инструкция на русском](README.ru.md)

This repository contains the current desktop's NixOS configuration, Hyprland configuration, Noctalia theme and user service, plus the old Waybar settings. The repository is public: never add VPN profiles, tokens, passwords, SSH keys or files from `~/.config/Happ`, `~/.config/Throne` or `~/.aws`.

## Layout

- `flake.nix` and `flake.lock` pin Nixpkgs and Noctalia. Noctalia is installed as a system package, so it is reproduced on a new machine without a separate `nix profile install`.
- `hosts/desktop/` contains the current PC's NixOS configuration, Hyprland settings, Happ module and generated hardware configuration.
- `home/hyprland.lua` adds Ctrl+Shift+S for a region screenshot copied only to the clipboard.
- `home/ghostty-config.ghostty` makes Ctrl+C copy a Ghostty selection and interrupt a command when nothing is selected.
- `home/noctalia-layout.toml` configures the slim top bar and a full-height left Noctalia bar with a taskbar and bottom launcher, without a second dock. It retains Dracula. Weather uses approximate IP location.
- `assets/night-garage.png` is an original wallpaper without baked-in UI. `home/fastfetch-config.jsonc` supplies a compact NixOS system readout; Fastfetch and JetBrainsMono Nerd Font are installed by the desktop NixOS config.
- `home/desktop/noctalia-settings.toml` contains the exact GUI settings from this PC, including two-monitor lock-screen positions. `home/laptop/noctalia-settings.toml` has the portable Dracula theme without those positions.
- `home/noctalia-shell.service` starts Noctalia in the graphical session.
- `scripts/restore-home.sh` installs the user settings with timestamped backups; `scripts/save.sh` snapshots Noctalia settings, reviews the diff, commits and pushes.

## Rebuild this PC

Run these commands from the repository directory:

```bash
sudo nixos-rebuild build --flake .#desktop
sudo nixos-rebuild switch --flake .#desktop
./scripts/restore-home.sh desktop
```

Then log out and back in. The current live system is not changed merely by cloning this repository. The old `nix profile` copy of Noctalia can be removed later, after confirming the system package works.

## Keep the repository up to date

Edit NixOS and Hyprland files **in this repository**. To apply a system edit, run `sudo nixos-rebuild switch --flake .#desktop`. To apply a change to a file under `home/`, run `./scripts/restore-home.sh desktop` and log out/in when Hyprland or systemd session startup changed.

Noctalia's Settings UI writes to `~/.local/state/noctalia/settings.toml`. To save that file and any edits to already tracked repository files, run:

```bash
./scripts/save.sh desktop
```

The script shows the full diff and asks before committing and pushing. It stages only already tracked files, so a new file needs an explicit `git add path/to/file`. Authenticate GitHub once on this machine with `gh auth login` (or configure SSH), because the connected account used for the initial upload is not a Git credential in your terminal. The repository is public, so read the diff before confirming.

To get updates on another computer:

```bash
git pull --ff-only
sudo nixos-rebuild switch --flake .#desktop
./scripts/restore-home.sh desktop
```

## Set up a laptop

Install NixOS on the laptop normally first. Clone this repository into the laptop user's home directory. Generate hardware settings on the laptop; do not copy the desktop's `hardware-configuration.nix`, whose disk UUIDs and kernel settings belong to the PC.

1. Copy `hosts/laptop/configuration.nix.example` to `hosts/laptop/configuration.nix` and the laptop's generated `/etc/nixos/hardware-configuration.nix` to `hosts/laptop/hardware-configuration.nix`.
2. Change hardware-specific services and `system.stateVersion` in the laptop configuration as needed. Keep the version generated for the laptop's first NixOS installation.
3. `hosts/laptop/hyprland.lua` uses automatic monitor layout. Set the laptop's display layout there if needed.
4. Add a `nixosConfigurations.laptop` entry to `flake.nix` using the desktop entry as a template and `./hosts/laptop/configuration.nix` as its module.
5. Commit these laptop files, then run `sudo nixos-rebuild build --flake .#laptop`, `sudo nixos-rebuild switch --flake .#laptop` and `./scripts/restore-home.sh laptop`.

After the first laptop setup, use `./scripts/save.sh laptop` there to save its Noctalia GUI settings. The laptop-specific hardware file can be committed if you want a fully reproducible laptop installation; inspect it before publishing. Application data, accounts, VPN subscriptions and passwords are separate from this configuration and need their own backup.
