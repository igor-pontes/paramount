local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local separator_for_empty_msg = wibox.widget({
	orientation = "vertical",
	opacity = 0.0,
	widget = wibox.widget.separator,
})


return wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.ui.colorize_text("NO NOTIFICATIONS", "#A0A0A0"),
	font = beautiful.font_light,
	halign = "center",
})

--return wibox.widget({
--	separator_for_empty_msg,
--	{
--		{
--			widget = wibox.widget.textbox,
--			markup = helpers.ui.colorize_text(string.upper("No Notifications"), "#A0A0A0"),
--			font = beautiful.font_light,
--			halign = "center",
--			--align = "center",
--		},
--		spacing = dpi(10),
--		layout = wibox.layout.fixed.vertical,
--	},
--	separator_for_empty_msg,
--	layout = wibox.layout.align.vertical,
--	expand = "none",
--})
