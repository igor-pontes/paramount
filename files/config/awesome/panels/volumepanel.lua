local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("helpers")
local menubar = require("menubar")
local lain  = require("lain")
local markup = lain.util.markup
local playerctl_daemon = require("signal.playerctl")

local playerctl_volume_bar = wibox.widget({
	max_value = 100,
	value = 100,
	forced_height = dpi(2),
	forced_width  = 200,
	shape = helpers.ui.rrect(dpi(2)),
	bar_shape = helpers.ui.rrect(dpi(2)),
	color = "#A790D5",
	background_color = "#505050",
	border_width = 0,
	widget = wibox.widget.progressbar,
})

local master_volume_bar = wibox.widget({
	max_value = 100,
	value = 100,
	forced_height = dpi(2),
	forced_width  = 200,
	shape = helpers.ui.rrect(dpi(2)),
	bar_shape = helpers.ui.rrect(dpi(2)),
	color = "#A790D5",
	background_color = "#505050",
	border_width = 0,
	widget = wibox.widget.progressbar,
})

local pctl_audio_icon = wibox.widget({
	font = beautiful.icon_font .. "Round 15",
	markup = "<span foreground='#A0A0A0'></span>",
	halign = "center",
	widget = wibox.widget.textbox,
})

local master_audio_icon = wibox.widget({
	font = beautiful.icon_font .. "Round 15",
	markup = "<span foreground='#A0A0A0'></span>",
	halign = "center",
	widget = wibox.widget.textbox,
})

local player_name = "MPD"

local pctl_volume = 100
local pctl_muted = false

return function(s)
	master_volume_bar:buttons(gears.table.join(
		awful.button({}, 4, nil, function()
			awful.spawn.with_shell("amixer sset Master 5%+")
			awesome.emit_signal("mastervolume::update")
		end),
		awful.button({}, 5, nil, function()
			awful.spawn.with_shell("amixer sset Master 5%-")
			awesome.emit_signal("mastervolume::update")
		end)
	))
	playerctl_volume_bar:buttons(gears.table.join(
		awful.button({}, 4, nil, function()
			awesome.emit_signal("playerctlvolume::update:variable", 0.05, true)
		end),
		awful.button({}, 5, nil, function()
			awesome.emit_signal("playerctlvolume::update:variable", 0.05, false)
		end)
	))

	local app_name = wibox.widget.textbox(markup.fontfg(beautiful.font_light, "#A0A0A0", string.upper("volume")))

	local pctl_vol_name = wibox.widget({
		markup = markup.fontfg(beautiful.font_light, "#A0A0A0", string.upper(player_name)),
		halign = "center",
		widget = wibox.widget.textbox,
	})

	local master_vol_name = wibox.widget({
		markup = markup.fontfg(beautiful.font_light, "#A0A0A0", "MASTER"),
		halign = "center",
		widget = wibox.widget.textbox,
	})
	
	local pctl_audio = wibox.widget({
		pctl_audio_icon,
		top = dpi(10),
		widget = wibox.container.margin,
	})

	local master_audio = wibox.widget({
		master_audio_icon,
		top = dpi(10),
		widget = wibox.container.margin,
	})

	master_audio:connect_signal("button::press", function() 
            	awful.spawn("amixer sset Master toggle", false)
		awesome.emit_signal("mastervolume::update")
	end)

	pctl_audio:connect_signal("button::press", function() 
		pctl_muted = not pctl_muted
		if not pctl_muted then 
			if pctl_volume ~= 0 then
				os.execute("playerctl -p " .. string.lower(player_name) .. " volume " .. tostring(pctl_volume))
			else
				awesome.emit_signal("playerctlvolume::update")
			end
		else
			if pctl_volume ~= 0 then
				os.execute("playerctl -p " .. string.lower(player_name) .. " volume 0")
			else
				awesome.emit_signal("playerctlvolume::update")
			end
		end
	end)

	local separator = wibox.widget({
		orientation = "vertical",
		color = "#A0A0A0",
		thickness = 0.3,--dpi(1),
		forced_width = dpi(40),
		widget = wibox.widget.separator
	})

	local volumes = wibox.widget({
			layout = wibox.layout.fixed.horizontal,
			{

				{
					layout = wibox.layout.align.vertical,
					pctl_vol_name,
					{
						{
							playerctl_volume_bar,
							direction = "east",
							widget = wibox.container.rotate,
						},
						margins = { left = dpi(25), right = dpi(25), top = dpi(5) },
						widget = wibox.container.margin,
					},
					pctl_audio
				},
				forced_width = dpi(60),
				widget = wibox.container.margin,
			},
			separator,
			{

				{
					layout = wibox.layout.align.vertical,
					master_vol_name,
					{
						{
							master_volume_bar,
							direction = "east",
							widget = wibox.container.rotate,
						},
						margins = { left = dpi(25), right = dpi(25), top = dpi(5) },
						widget = wibox.container.margin,
					},
					master_audio
				},
				forced_width = dpi(60),
				widget = wibox.container.margin,
			},
	})

	local dismiss_icon = wibox.widget.textbox(markup.fontfg(beautiful.font_light, "#A0A0A0", "X"))
	local dismiss = wibox.widget({
		{
			dismiss_icon,
			left = dpi(6),
			right = dpi(0),
			widget = wibox.container.margin,
		},
		widget = wibox.container.place,
	})

	helpers.ui.add_hover_and_release_cursor(dismiss, "hand1")

	helpers.ui.add_hover_cursor(master_audio_icon, "hand1")

	helpers.ui.add_hover_cursor(pctl_audio_icon, "hand1")

	s.volumepanel = awful.popup({
		type = "dock",
		screen = s,
		cursor = "hand3",
		--- For antialiasing: The real shape is set in widget_template
		shape = gears.shape.rectangle,
		maximum_width = dpi(200),
		minimum_width = dpi(200),
		maximum_height = dpi(250),
		minimum_height = dpi(250),
		bg = "#00000000",
		ontop = true,
		visible = false,
		placement = function(w) 
			awful.placement.top_right(
				w,
				{ honor_workarea = true, margins = { top = dpi(5), right = dpi(5) } }
			)
		end,
		widget = {
			{
				layout = wibox.layout.fixed.vertical,
				{
					{
						{
							layout = wibox.layout.align.horizontal,
							{
								app_name,
								layout = wibox.layout.align.horizontal,
							},
							nil,
							dismiss,
						},
						margins = { top = dpi(5), bottom = dpi(5), left = dpi(15), right = dpi(15) },
						widget = wibox.container.margin,
					},
					bg = "#303030",
					widget = wibox.container.background,
				},
				{
					{
						volumes,
						halign = "center",
						widget = wibox.container.place,
					},
					margins = {top = dpi(10), bottom = dpi(10)},
					widget = wibox.container.margin,
				},
			},
			--- Anti-aliasing container
			shape = helpers.ui.rrect(dpi(2)),
			bg = "#222222c0",
			widget = wibox.container.background,
		},
	})

	dismiss:connect_signal("button::release", function() 
		awesome.emit_signal("volumepanel::toggle", s)
	end)

	awesome.connect_signal("volumepanel::toggle", function(scr)
		if scr == s then
			s.volumepanel.visible = not s.volumepanel.visible
		end
	end)

	playerctl_daemon:connect_signal("volume", function(_, vol, _)
		if vol == 0 and pctl_volume ~= 0 and pctl_muted then
			pctl_muted = true
		else
			pctl_muted = false
		end
		awesome.emit_signal("playerctlvolume::update")
	end)

	playerctl_daemon:connect_signal("metadata", function(_, _, _, _, _, _, player)
		player_name = player
		pctl_vol_name:set_markup(markup.fontfg(beautiful.font_light, "#A0A0A0", string.upper(player_name)))
	end)

	awesome.connect_signal("playerctlvolume::update", function()
		awful.spawn.easy_async_with_shell(
			"playerctl volume -p " .. string.lower(player_name),
			function(out)
				if not pctl_muted then 
					pctl_volume = tonumber(out)
					if pctl_volume == 0 then 
						playerctl_volume_bar:set_value(0)
					end
					pctl_audio_icon:set_markup("<span foreground='#A0A0A0'></span>")
				else
					pctl_audio_icon:set_markup("<span foreground='#A0A0A0'></span>")
				end
				if pctl_volume then 
					playerctl_volume_bar:set_value(pctl_volume * 100)
				else
					playerctl_volume_bar:set_value(0)
				end
			end
		)
	end)

	awesome.connect_signal("playerctlvolume::update:variable", function(amount, increase)
		if increase then 
			if not pctl_muted then 
				awful.spawn.with_shell("playerctl -p " .. string.lower(player_name) .. " volume 0.05+")
			end
			if pctl_volume then
				pctl_volume = pctl_volume + amount
			end
		else
			if not pctl_muted then 
				awful.spawn.with_shell("playerctl -p " .. string.lower(player_name) .. " volume 0.05-")
			end
			if pctl_volume then
				pctl_volume = pctl_volume - amount
			end
		end
		if pctl_volume < 0 then
			pctl_volume = 0
		end
		awesome.emit_signal("playerctlvolume::update")
	end)

	awesome.connect_signal("mastervolume::update", function()
		awful.spawn.easy_async_with_shell(
			"amixer get Master",
			function(out)
				local vol, playback = string.match(out, "([%d]+)%%.*%[([%l]*)")
				master_volume_bar:set_value(tonumber(vol))
				if playback == "off" then 
					master_audio_icon:set_markup("<span foreground='#A0A0A0'></span>")
				else
					master_audio_icon:set_markup("<span foreground='#A0A0A0'></span>")
				end
			end
		)
	end)
end

