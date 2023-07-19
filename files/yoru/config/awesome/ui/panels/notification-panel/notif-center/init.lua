local wibox = require("wibox")

local notif_center = function(s)
	s.notifbox_layout = require("ui.panels.notification-panel.notif-center.build-notifbox").notifbox_layout
	s.notifbox_clear = require("ui.panels.notification-panel.notif-center.build-notifbox").notifbox_clear

	return wibox.widget({
		s.notifbox_clear,
		wibox.widget {

			s.notifbox_layout,
    			top = 10,
			layout = wibox.container.margin,
		},
		layout = wibox.layout.fixed.vertical,
	})
end

return notif_center
