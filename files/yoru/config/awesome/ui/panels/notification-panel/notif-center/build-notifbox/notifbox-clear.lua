local wibox = require("wibox")
local widgets = require("ui.widgets")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local builder = require("ui.panels.notification-panel.notif-center.build-notifbox.notifbox-ui-elements")
local notifbox_core = require("ui.panels.notification-panel.notif-center.build-notifbox")

local notifbox_layout = notifbox_core.notifbox_layout
local reset_notifbox_layout = notifbox_core.reset_notifbox_layout

clear_button = function()
	
	local clear_template = widgets.button.elevated.normal({
		paddings = dpi(5),
		normal_bg = beautiful.widget_bg,
		child = builder.clear_title() ,
		on_release = function()
			reset_notifbox_layout()
			collectgarbage("collect")
		end,
	})

	--- Put the generated template to a container
	local clearall = wibox.widget({
		clear_template,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.border_radius)
		end,
		widget = wibox.container.background,
	})
	
	collectgarbage("collect")
	return clearall
end

return clear_button
