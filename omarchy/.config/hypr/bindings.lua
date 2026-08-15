-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Colemak Vim-style focus
o.bind("SUPER + H", "Focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + N", "Focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + E", "Focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + I", "Focus right", hl.dsp.focus({ direction = "r" }))

-- These keys have Omarchy application defaults.
hl.unbind("SUPER + SHIFT + N") -- was: Editor
hl.unbind("SUPER + SHIFT + E") -- was: Email

o.bind("SUPER + SHIFT + L", "Editor", { omarchy = "editor" })
o.bind("SUPER + SHIFT + H", "Swap left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + N", "Swap down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + E", "Swap up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + I", "Swap right", hl.dsp.window.swap({ direction = "r" }))

-- Custom web apps
hl.unbind("SUPER + SHIFT + C") -- was: HEY Calendar
hl.unbind("SUPER + SHIFT + ALT + E") -- was: New HEY email
hl.unbind("SUPER + SHIFT + P") -- was: Google Photos
hl.unbind("SUPER + SHIFT + ALT + A") -- was: Grok

o.bind("SUPER + SHIFT + C", "Calendar", {
	webapp = "https://calendar.google.com",
})

o.bind("SUPER + SHIFT + ALT + E", "Email", {
	webapp = "https://mail.google.com",
})

o.bind("SUPER + SHIFT + T", "Todo", {
	webapp = "https://app.todoist.com/app/",
	focus = true,
})

o.bind("SUPER + SHIFT + P", "Immich", {
	webapp = "https://immich.coati-newton.ts.net",
	focus = true,
})

o.bind("SUPER + SHIFT + ALT + A", "Gemini", {
	webapp = "https://gemini.google.com",
})

-- Custom desktop apps
hl.unbind("SUPER + SHIFT + SLASH") -- was: 1Password
hl.unbind("SUPER + SHIFT + G") -- was: Signal

o.bind("SUPER + SHIFT + G", "Discord", {
	launch = "vesktop",
	focus = "^vesktop$",
})

o.bind("SUPER + SHIFT + SLASH", "Passwords", {
	launch = "bitwarden-desktop",
})

-- Standing desk via Home Assistant
o.bind("SHIFT + XF86AudioPrev", "Desk sitting position", "~/.local/bin/desk-memory sit", {
	locked = true,
})

o.bind("SHIFT + XF86AudioNext", "Desk standing position", "~/.local/bin/desk-memory stand", {
	locked = true,
})
