local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local upower_daemon = require("signal.battery")
local gears = require("gears")
local apps = require("configuration.apps")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")
local icons = require("icons")
local wbutton = require("ui.widgets.button")

--- Battery Widget
--- ~~~~~~~~~~~~~~

return function()
	local temp_value = awful.widget.watch(
		'nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader', 5
	)

	local gpu_icon = wibox.widget({
		image = gears.color.recolor_image(icons.gpu, "#ffffff"),
		widget = wibox.widget.imagebox,
	})

	local gpu_temp = wibox.widget({
		gpu_icon,
		layout = wibox.layout.fixed.horizontal,
	})

	local gpu_temp_text = wibox.widget({
		id = "percent_text",
		text = "°C",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local gpu_temp_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		--spacing = dpi(5),
		{
			gpu_temp,
			top = dpi(1),
			bottom = dpi(1),
			right = dpi(5),
			widget = wibox.container.margin,
		},
		temp_value,
		gpu_temp_text,
	})

	local widget = wbutton.elevated.state({
		child = gpu_temp_widget,
		normal_bg = beautiful.wibar_bg,
	})

	return widget
end
