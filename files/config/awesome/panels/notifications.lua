--
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

return function(s)

	notifbox = require("panels.notifbox")
	
	s.notifbox_layout = notifbox.notifbox_layout

	local tolow = string.lower

	local app_name = wibox.widget.textbox(markup.fontfg(beautiful.font_light, "#A0A0A0", string.upper("notifications")))

	local space = wibox.widget.textbox(markup.font("Roboto 3", "   "))

	local dismiss = wibox.widget({
		{
			{
				markup = markup.fontfg(beautiful.font, "#A0A0A0", "CLEAR ALL"),
				widget = wibox.widget.textbox,
			},
			left = dpi(6),
			right = dpi(0),
			widget = wibox.container.margin,
		},
		widget = wibox.container.place,
	})

	helpers.ui.add_hover_cursor(dismiss, "hand1")
	dismiss:connect_signal("button::release", function()
		notifbox.reset_notifbox_layout()
	end)


	--local actions = wibox.widget({
	--	notification = n,
	--	base_layout = wibox.widget({
	--		spacing = dpi(3),
	--		layout = wibox.layout.flex.horizontal,
	--	}),
	--	widget_template = {
	--		{
	--			{
	--				{
	--					id = "text_role",
	--					font = beautiful.font_light,
	--					widget = wibox.widget.textbox,
	--				},
	--				left = dpi(6),
	--				right = dpi(6),
	--				widget = wibox.container.margin,
	--			},
	--			widget = wibox.container.place,
	--		},
	--		bg = "#303030",
	--		forced_height = dpi(25),
	--		forced_width = dpi(70),
	--		widget = wibox.container.background,
	--	},
	--	style = {
	--		underline_normal = false,
	--		underline_selected = true,
	--	},
	--	widget = naughty.list.actions,
	--})
	
	s.notifs = awful.popup({
		type = "dock",
		screen = s,
		--cursor = "hand2",
		--- For antialiasing: The real shape is set in widget_template
		shape = gears.shape.rectangle,
		maximum_width = dpi(350),
		minimum_width = dpi(350),
		--maximum_height = dpi(450),
		maximum_height = awful.screen.focused().geometry.height - 50,
		bg = "#00000000",
		ontop = true,
		visible = false,
		placement = function(w) 
			awful.placement.top_right(w, { honor_workarea = true, margins = { top = dpi(5), right = dpi(5) }})
			--awful.placement.maximize_vertically(
			--	w,
			--	{ honor_workarea = true, margins = { top = dpi(5), bottom = dpi(5) } }
			--)
		end,
		widget = {
			{
				--layout = wibox.layout.fixed.vertical,
				layout = wibox.layout.align.vertical,
				{
					{
						{
							layout = wibox.layout.align.horizontal,
							app_name,
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
						s.notifbox_layout,
						layout = wibox.layout.fixed.vertical,
					},
					margins = dpi(15),
					widget = wibox.container.margin,
				},
			},
			--- Anti-aliasing container
			shape = helpers.ui.rrect(dpi(2)),
			bg = "#222222c0",
			widget = wibox.container.background,
		},
	})

	awesome.connect_signal("notifs::toggle", function(scr)
		if scr == s then
			s.notifs.visible = not s.notifs.visible
		end
	end)
end
