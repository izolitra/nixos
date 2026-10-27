-- Keep the system configuration and add user-specific keybindings.
require("/etc/xdg/hypr/hyprland")

hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("/run/current-system/sw/bin/noctalia msg screenshot-region --no-annotate --copy-to-clipboard --no-save-to-file"))
