local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("helpers")
local menubar = require("menubar")
local lain  = require("lain")
local markup = lain.util.markup
--local widgets = require("helpers.widgets")

--- Naughty Notifications with animation
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 6
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.position = "top_right"

local function get_oldest_notification()
	for _, notification in ipairs(naughty.active) do
		if notification and notification.timeout > 0 then
			return notification
		end
	end

	--- Fallback to first one.
	return naughty.active[1]
end

--- Handle notification icon
naughty.connect_signal("request::icon", function(n, context, hints)
	--- Handle other contexts here
	if context ~= "app_icon" then
		return
	end

	--- Use XDG icon
	local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

	if path then
		n.icon = path
	end
end)

--- Use XDG icon
naughty.connect_signal("request::action_icon", function(a, context, hints)
	a.icon = menubar.utils.lookup_icon(hints.id)
end)

naughty.connect_signal("request::display", function(n)

	--- table of icons
	local app_icons = {
		["firefox"] = { icon = "" },
		["discord"] = { icon = "" },
		["music"] = { icon = "" },
		["screenshot tool"] = { icon = "" },
		["color picker"] = { icon = "" },
	}

	local app_icon = nil
	local tolow = string.lower

	if app_icons[tolow(n.app_name)] then
		app_icon = app_icons[tolow(n.app_name)].icon
	else
		app_icon = ""
	end

	local app_icon_n = wibox.widget({
		font = beautiful.icon_font .. "Round 10",
		markup = "<span foreground='" .. "#A0A0A0" .. "'>" .. app_icon .. "</span>",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local icon = wibox.widget({
		{
			{
				{
					image = n.icon,
					resize = true,
					clip_shape = gears.shape.rectangle,
					halign = "center",
					valign = "center",
					widget = wibox.widget.imagebox,
				},
				border_width = dpi(1),
				border_color = "#303030",
				shape = helpers.ui.rrect(dpi(2)),
				widget = wibox.container.background,
			},
			strategy = "exact",
			height = dpi(50),
			width = dpi(50),
			widget = wibox.container.constraint,
		},
		layout = wibox.layout.stack,
	})

	local app_name = wibox.widget.textbox(markup.fontfg(beautiful.font_light, "#A0A0A0", string.upper(n.app_name)))

	local space = wibox.widget.textbox(markup.font("Roboto 3", "   "))

	local dismiss = wibox.widget({
		{
			{
				markup = markup.fontfg(beautiful.font, "#A0A0A0", "X"),
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
		n:destroy(naughty.notification_closed_reason.dismissed_by_user)
	end)
	local title = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		wibox.widget.textbox(markup.fontfg(beautiful.font_light, "#A0A0A0", n.title))
	})

	local message = wibox.widget({
		widget = wibox.container.scroll.horizontal,
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		fps = 60,
		speed = 75,
		wibox.widget.textbox(markup.fontfg(beautiful.font_light, "#A0A0A0", n.message))
	})

	local actions = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = dpi(3),
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = {
			{
				{
					{
						id = "text_role",
						font = beautiful.font_light,
						widget = wibox.widget.textbox,
					},
					left = dpi(6),
					right = dpi(6),
					widget = wibox.container.margin,
				},
				widget = wibox.container.place,
			},
			--bg = "#303030",
			bg = "#4E4E4E",
			forced_height = dpi(25),
			forced_width = dpi(70),
			widget = wibox.container.background,
		},
		style = {
			underline_normal = false,
			underline_selected = true,
		},
		widget = naughty.list.actions,
	})
	helpers.ui.add_hover_cursor(actions, "hand1")


	local widget = naughty.layout.box({
		notification = n,
		type = "notification",
		--cursor = "hand2",
		--- For antialiasing: The real shape is set in widget_template
		shape = gears.shape.rectangle,
		maximum_width = dpi(350),
		minimum_width = dpi(350),
		maximum_height = dpi(180),
		bg = "#00000000",
		widget_template = {
			{
				layout = wibox.layout.fixed.vertical,
				{
					{
						{
							layout = wibox.layout.align.horizontal,
							--app_name,
							{
								app_icon_n,
								space,
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
							layout = wibox.layout.fixed.horizontal,
							spacing = dpi(10),
							icon,
							{
								expand = "none",
								layout = wibox.layout.align.vertical,
								nil,
								{
									layout = wibox.layout.fixed.vertical,
									title,
									message,
								},
								nil,
							},
						},
						{
							helpers.ui.vertical_pad(dpi(10)),
							{
								actions,
								shape = helpers.ui.rrect(dpi(2)),
								widget = wibox.container.background,
							},
							visible = n.actions and #n.actions > 0,
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

	--- Don't destroy the notification on click
	widget.buttons = {}

	local timeout = 0
	widget:connect_signal("mouse::enter", function()
		timeout = n.timeout
		n:set_timeout(4294967)
	end)

	widget:connect_signal("mouse::leave", function()
		n:set_timeout(timeout)
	end)

	local notification_height = widget.height + beautiful.notification_spacing
	local total_notifications_height = #naughty.active * notification_height

	if total_notifications_height > n.screen.workarea.height then
		get_oldest_notification():destroy(naughty.notification_closed_reason.too_many_on_screen)
	end

	--- Destroy popups notifs if dont_disturb mode is on
	if _G.dnd_state then
		naughty.destroy_all_notifications(nil, 1)
	end
end)
require(... .. ".playerctl")
