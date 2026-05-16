------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = "HDMI-A-3",
	mode = "1920x1080@60",
	position = "1920x0",
	scale = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "ghostty"
local fileManager = "dolphin"
local menu = "wofi --show drun"
local snip = "snip"
local librewolf = "librewolf"
local vlc = "vlc"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar &")
	hl.exec_cmd("hyprpaper --config ~/.config/hypr/hyprpaper.conf &")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland GTK_THEME GTK_USE_PORTAL QT_QPA_PLATFORMTHEME"
	)
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("GTK_THEME", "Adwaita:dark")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 1,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	cursor = { enable_hyprcursor = false, no_hardware_cursors = true },

	decoration = {
		rounding = 0,
		rounding_power = 0,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		-- infamous xset r rate 200 35;
		repeat_rate = 35,
		repeat_delay = 200,
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = false,
		},
	},
})

---------------------
---- KEYBINDINGS ----
---------------------

local main_mod = "SUPER" -- Sets "Windows" key as main modifier

-- Smart move/resize: if alone on workspace, resize by 50% in direction.
-- If resized once already (window not centered), move to prev/next workspace.
-- last_resize_dir tracks the last direction resized, for double-press detection.
local last_resize_dir = nil

local function smart_move_or_resize(direction)
	local ws = hl.get_active_workspace()
	if ws and ws.windows <= 1 then
		-- Only one window on workspace
		if last_resize_dir == direction then
			-- Second press in same direction: move to adjacent workspace
			if direction == "left" then
				hl.dispatch(hl.dsp.window.move({ workspace = "e-1", follow = true }))
			elseif direction == "right" then
				hl.dispatch(hl.dsp.window.move({ workspace = "e+1", follow = true }))
			elseif direction == "up" then
				hl.dispatch(hl.dsp.window.move({ workspace = "e-1", follow = true }))
			elseif direction == "down" then
				hl.dispatch(hl.dsp.window.move({ workspace = "e+1", follow = true }))
			end
			last_resize_dir = nil
		else
			-- First press: float and resize to 50% in that direction
			local monitor = hl.get_active_monitor()
			if monitor then
				local hw = math.floor(monitor.width / 2)
				local hh = math.floor(monitor.height / 2)
				hl.dispatch(hl.dsp.window.float({ action = "set" }))
				if direction == "left" then
					hl.dispatch(hl.dsp.window.resize({ x = hw, y = monitor.height, relative = false }))
					hl.dispatch(hl.dsp.window.move({ x = 0, y = 0, relative = false }))
				elseif direction == "right" then
					hl.dispatch(hl.dsp.window.resize({ x = hw, y = monitor.height, relative = false }))
					hl.dispatch(hl.dsp.window.move({ x = hw, y = 0, relative = false }))
				elseif direction == "up" then
					hl.dispatch(hl.dsp.window.resize({ x = monitor.width, y = hh, relative = false }))
					hl.dispatch(hl.dsp.window.move({ x = 0, y = 0, relative = false }))
				elseif direction == "down" then
					hl.dispatch(hl.dsp.window.resize({ x = monitor.width, y = hh, relative = false }))
					hl.dispatch(hl.dsp.window.move({ x = 0, y = hh, relative = false }))
				end
			end
			last_resize_dir = direction
		end
	else
		-- Multiple windows: move the tiled window in direction
		last_resize_dir = nil
		if direction == "left" then
			hl.dispatch(hl.dsp.window.move({ direction = "left" }))
		elseif direction == "right" then
			hl.dispatch(hl.dsp.window.move({ direction = "right" }))
		elseif direction == "up" then
			hl.dispatch(hl.dsp.window.move({ direction = "up" }))
		elseif direction == "down" then
			hl.dispatch(hl.dsp.window.move({ direction = "down" }))
		end
	end
end

-- Launch terminal
hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + grave", hl.dsp.exec_cmd(terminal))

-- Applications
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(main_mod .. " + L", hl.dsp.exec_cmd(librewolf))
hl.bind(main_mod .. " + V", hl.dsp.exec_cmd(vlc))
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + X", hl.dsp.exec_cmd(snip))

-- Session
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(
	main_mod .. " + SHIFT + ESCAPE",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd("pkill waybar; waybar &"))
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Window management
hl.bind(main_mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())

-- Move focus with main_mod + WASD
hl.bind(main_mod .. " + A", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + D", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + W", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + S", hl.dsp.focus({ direction = "down" }))

-- Swap windows with main_mod + SHIFT + WASD
hl.bind(main_mod .. " + SHIFT + A", function()
	hl.dispatch(hl.dsp.window.swap({ direction = "left" }))
end)
hl.bind(main_mod .. " + SHIFT + D", function()
	hl.dispatch(hl.dsp.window.swap({ direction = "right" }))
end)
hl.bind(main_mod .. " + SHIFT + W", function()
	hl.dispatch(hl.dsp.window.swap({ direction = "up" }))
end)
hl.bind(main_mod .. " + SHIFT + S", function()
	hl.dispatch(hl.dsp.window.swap({ direction = "down" }))
end)

-- Smart move/resize with main_mod + CTRL + WASD
-- With multiple windows: moves window in direction
-- With single window: resizes to 50% on first press, moves to adjacent workspace on second press
hl.bind(main_mod .. " + CTRL + A", function()
	smart_move_or_resize("left")
end)
hl.bind(main_mod .. " + CTRL + D", function()
	smart_move_or_resize("right")
end)
hl.bind(main_mod .. " + CTRL + W", function()
	smart_move_or_resize("up")
end)
hl.bind(main_mod .. " + CTRL + S", function()
	smart_move_or_resize("down")
end)

-- Resize submap (SUPER + R to enter, ESC to exit)
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("A", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
	hl.bind("D", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
	hl.bind("W", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
	hl.bind("S", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Switch workspaces with main_mod + [0-9]
-- Move active window to a workspace with main_mod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace navigation
hl.bind(main_mod .. " + bracketleft", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { mouse = true })
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { mouse = true })

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume and Media Control (with OSD indicators)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+ && swayosd-client --output-volume raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%- && swayosd-client --output-volume lower"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })

-- Screen brightness (with OSD)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl s 5%+ && swayosd-client --brightness raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl s 5%- && swayosd-client --brightness lower"),
	{ locked = true, repeating = true }
)

-- Audio output toggle
hl.bind("F12", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-audio.sh"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
