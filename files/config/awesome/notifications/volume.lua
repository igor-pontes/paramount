local gears = require("gears")
local awful = require("awful")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
--local icons = require("icons")

--- Volume OSD
--- ~~~~~~~~~~

local osd_header = wibox.widget({
	text = "Volume",
	font = beautiful.font_light,
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local osd_value = wibox.widget({
	text = "0%",
	font = beautiful.font_light,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local volume_value = 0

local slider_osd = wibox.widget({
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

local volume_osd_height = dpi(100)
local volume_osd_width = dpi(250)

screen.connect_signal("request::desktop_decoration", function(s)
	local s = s or {}
	s.show_vol_osd = false

	s.volume_osd_overlay = awful.popup({
		type = "notification",
		screen = s,
		height = volume_osd_height,
		width = volume_osd_width,
		maximum_height = volume_osd_height,
		maximum_width = volume_osd_width,
		bg = beautiful.transparent,
		offset = dpi(5),
		ontop = true,
		visible = false,
		--preferred_anchors = "middle",
		--preferred_positions = { "left", "right", "top", "bottom" },
		placement = function(w) 
			awful.placement.top_left(
				w,
				{ honor_workarea = true, margins = { top = dpi(5), left = dpi(5) } }
			)
		end,
		widget = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						{
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(5),
							{
								layout = wibox.layout.align.horizontal,
								expand = "none",
								osd_header,
								nil,
								osd_value,
							},
							slider_osd,
						},
						spacing = dpi(10),
						layout = wibox.layout.fixed.vertical,
					},
				},
				left = dpi(24),
				top = dpi(20),
				right = dpi(24),
				bottom = dpi(24),
				widget = wibox.container.margin,
			},
			bg = "#303030c0",
			shape = helpers.ui.rrect(dpi(2)),
			widget = wibox.container.background,
		},
	})
end)

local hide_osd = gears.timer({
	timeout = 2,
	autostart = true,
	callback = function()
		local focused = awful.screen.focused()
		focused.volume_osd_overlay.visible = false
		focused.show_vol_osd = false
	end,
})

local update_slider = function()
	awful.spawn.easy_async_with_shell(
		"amixer sget Master | awk -F'[][]' '/Right:|Mono:/ && NF > 1 {sub(/%/, \"\"); printf \"%0.0f\", $2}'",
		function(stdout)
			local value = string.gsub(stdout, "^%s*(.-)%s*$", "%1")
			slider_osd:set_value(tonumber(value))
			--slider_osd.value = tonumber(value) * 100
			--alsabar.bar:set_value(alsabar._current_level / 100)
			osd_value.text = value .. "%"
		end
	)
end

awesome.connect_signal("module::volume_osd:rerun", function()
	if hide_osd.started then
		hide_osd:again()
	else
		hide_osd:start()
	end
end)

--awesome.connect_signal("widget::volume", function()
awesome.connect_signal("module::volume_osd:show", function(bool)
	update_slider()
	awful.screen.focused().volume_osd_overlay.visible = bool
	if bool then
		awesome.emit_signal("module::volume_osd:rerun")
	else
		if hide_osd.started then
			hide_osd:stop()
		end
	end
end)
