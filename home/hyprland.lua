-- Keep the system configuration and add user-specific keybindings.
require("/etc/xdg/hypr/hyprland")

-- Small appearance overrides; preserve system keybinds and animation curves.
hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 12,
        border_size = 2,
        col = {
            active_border = { colors = {"rgba(bd93f9ee)", "rgba(ff79c6bb)"}, angle = 45 },
            inactive_border = "rgba(6272a488)",
        },
    },
    decoration = {
        rounding = 12,
        shadow = {
            enabled = true,
            range = 12,
            render_power = 2,
            color = 0x66000000,
        },
    },
})

-- The system config uses this shortcut for the special workspace; replace it with a region screenshot.
hl.unbind("SUPER + SHIFT + S")
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("/run/current-system/sw/bin/noctalia msg screenshot-region --no-annotate --copy-to-clipboard --no-save-to-file"))
