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

calendar_text = wibox.widget.textbox("")
return function(s)

	local tolow = string.lower

	local app_icon = ""
	local app_icon_n = wibox.widget({
		font = beautiful.icon_font .. "Round 10",
		markup = "<span foreground='" .. "#A0A0A0" .. "'>" .. app_icon .. "</span>",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local app_name = wibox.widget.textbox(markup.fontfg(beautiful.font_light, "#A0A0A0", string.upper("calendar")))

	local space = wibox.widget.textbox(markup.font("Roboto 3", "   "))

	local dismiss = wibox.widget({
		{
			{
				markup = markup.fontfg(beautiful.font_icon, "#A0A0A0", " "),
				widget = wibox.widget.textbox,
			},
			left = dpi(6),
			right = dpi(0),
			widget = wibox.container.margin,
		},
		widget = wibox.container.place,
	})

	--dismiss:connect_signal("button::release", function()
	--	n:destroy(naughty.notification_closed_reason.dismissed_by_user)
	--end)

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

	s.calendar = awful.popup({
		type = "dock",
		screen = s,
		--cursor = "hand2",
		--- For antialiasing: The real shape is set in widget_template
		shape = gears.shape.rectangle,
		maximum_width = dpi(250),
		minimum_width = dpi(250),
		maximum_height = dpi(200),
		minimum_height = dpi(200),
		bg = "#00000000",
		ontop = true,
		visible = false,
		placement = function(w) 
			awful.placement.top_right(
				w,
				{ honor_workarea = true, margins = { top = dpi(5), right = dpi(210) } }
			)
			--awful.placement.maximize_vertically(
			--	w,
			--	{ honor_workarea = true, margins = { top = dpi(2) } }
			--)
		end,
		widget = {
			{
				layout = wibox.layout.fixed.vertical,
				{
					{
						{
							layout = wibox.layout.align.horizontal,
							--app_name,
							{
								--app_icon_n,
								--space,
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
						layout = wibox.layout.fixed.vertical,
						{
							calendar_text,
							margins = { top = dpi(5), left = dpi(15) },
							widget = wibox.container.margin,
						},
						{
							helpers.ui.vertical_pad(dpi(10)),
							{
								--actions,
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
			},
			--- Anti-aliasing container
			shape = helpers.ui.rrect(dpi(2)),
			bg = "#222222c0",
			widget = wibox.container.background,
		},
	})

	awesome.connect_signal("calendar::toggle", function(scr, txt)
		if scr == s then
			s.calendar.visible = not s.calendar.visible
		end
	end)
	awesome.connect_signal("calendar::text", function(txt)
		calendar_text:set_markup(markup.font("AestheticIosevka Regular 10", txt))
	end)
end
