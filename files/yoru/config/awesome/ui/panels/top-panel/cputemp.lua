local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local upower_daemon = require("signal.battery")
local gears = require("gears")
local apps = require("configuration.apps")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")
local wbutton = require("ui.widgets.button")

--- Battery Widget
--- ~~~~~~~~~~~~~~

return function()
	local temp_value = awful.widget.watch(
		-- 'bash -c "sensors | grep Tctl | awk \'{print $2}\' | sed \'s/C/C   /\' | sed \'s/+//\' | sed \'s/\.\d$//\'"', 5
		'bash -c "sensors | grep Tctl | awk \'{print $2}\' | sed \'s/C/C   /\' | sed \'s/+//\' | sed \'s/\\.\\([0-9]\\)//g\'"', 5
	)

	local cpu_icon = wibox.widget({
		markup = helpers.ui.colorize_text("", beautiful.white),
		font = "icomoon bold",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local cpu_temp = wibox.widget({
		cpu_icon,
		layout = wibox.layout.fixed.horizontal,
	})

	local cpu_temp_text = wibox.widget({
		id = "percent_text",
		text = "C",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local cpu_temp_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			cpu_temp,
			top = dpi(1),
			bottom = dpi(1),
			widget = wibox.container.margin,
		},
		temp_value,
		--cpu_temp_text,
	})

	local widget = wbutton.elevated.state({
		child = cpu_temp_widget,
		normal_bg = beautiful.wibar_bg,
	})

	return widget
end
