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
--local widgets = require("helpers.widgets")

local volume_bar = wibox.widget({
	max_value = 100,
	value = 100,
	forced_height = 5,
	forced_width  = 200,
	shape = helpers.ui.rrect(dpi(2)),
	bar_shape = helpers.ui.rrect(dpi(2)),
	color = "#A790D5",
	background_color = "#505050",
	border_width = 0,
	widget = wibox.widget.progressbar,
})

return function(s)

	s.playerctlvolume = awful.popup({
		type = "dock",
		screen = s,
		--cursor = "hand2",
		--- For antialiasing: The real shape is set in widget_template
		shape = gears.shape.rectangle,
		maximum_width = dpi(40),
		minimum_width = dpi(40),
		maximum_height = dpi(200),
		minimum_height = dpi(200),
		bg = "#00000000",
		ontop = true,
		visible = false,
		placement = function(w) 
			awful.placement.top_right(
				w,
				{ honor_workarea = true, margins = { top = dpi(5), right = dpi(190) } }
			)
			--awful.placement.maximize_vertically(
			--	w,
			--	{ honor_workarea = true, margins = { top = dpi(2) } }
			--)
		end,
		widget = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						{
							volume_bar,
							direction = "east",
							widget = wibox.container.rotate,
						},
						margins = { left = dpi(1), right = dpi(1) },
						widget = wibox.container.margin,
					},
					{
						helpers.ui.vertical_pad(dpi(10)),
						{
							shape = helpers.ui.rrect(dpi(2)),
							widget = wibox.container.background,
						},
						--visible = n.actions and #n.actions > 0,
						visible = true,
						layout = wibox.layout.fixed.vertical,
					},
				},
				margins = dpi(15),
				widget = wibox.container.margin,
			},
			--- Anti-aliasing container
			shape = helpers.ui.rrect(dpi(2)),
			bg = "#222222c0",
			widget = wibox.container.background,
		},
	})

	awesome.connect_signal("playerctlvolume::toggle", function(scr, txt)
		awful.spawn.easy_async_with_shell(
			"playerctl volume",
			function(out)
				volume_bar:set_value(tonumber(out) * 100)
				--osd_value.text = value .. "%"
			end
		)
		if scr == s then
			s.playerctlvolume.visible = not s.playerctlvolume.visible
		end
	end)
	awesome.connect_signal("playerctlvolume::update", function()
		awful.spawn.easy_async_with_shell(
			"playerctl volume",
			function(out)
				volume_bar:set_value(tonumber(out) * 100)
				--osd_value.text = value .. "%"
			end
		)
	end)
end

