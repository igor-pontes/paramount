local gears = require("gears")
local helpers = require("helpers")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local string, os = string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.icon_font = "Material Icons "
theme.white = "#edeff0"
theme.black = "#121212"
theme.transparent = "#00000000"
theme.background = "#121212FF"
theme.lighter_black = "#4E4E4E"

-- Notification
theme.notification_spacing = dpi(4)

-- Systray
theme.systray_icon_spacing = dpi(10)

--- Black
theme.color0 = "#232526"
theme.color8 = "#2c2e2f"

--- Red
theme.color1 = "#df5b61"
theme.color9 = "#e8646a"

--- Green
theme.color2 = "#78b892"
theme.color10 = "#81c19b"

--- Yellow
theme.color3 = "#de8f78"
theme.color11 = "#e79881"

--- Blue
theme.color4 = "#6791c9"
theme.color12 = "#709ad2"

--- Magenta
theme.color5 = "#A790D5"
theme.color13 = "#9B72CF"

--- Cyan
theme.color6 = "#67afc1"
theme.color14 = "#70b8ca"

--- White
theme.color7 = "#e4e6e7"
theme.color15 = "#f2f4f5"

--theme.flash_focus_start_opacity = 0.9
--theme.flash_focus_step = 0.02

theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.icon_dir                                  = os.getenv("HOME") .. "/.config/awesome/themes/icons"
theme.wallpaper                                 = os.getenv("HOME") .. "/.config/awesome/themes/wall.png"
theme.font                                      = "AestheticIosevka Bold 10"
theme.font_light                                = "AestheticIosevka Regular 10"
theme.taglist_font                              = "AestheticIosevka Italic Regular 8"
theme.fg_normal                                 = "#A0A0A0"
theme.fg_focus                                  = "#A790D5"
theme.bg_focus                                  = "#303030"
theme.bg_normal                                 = "#242424"
theme.fg_urgent                                 = "#CC9393"
theme.bg_urgent                                 = "#006B8E"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#303030"
theme.border_focus                              = "#4E4E4E"
theme.taglist_fg_focus                          = "#FFFFFF"
theme.tasklist_bg_normal                        = "#222222"
theme.tasklist_fg_focus                         = "#A790D5"
theme.menu_height                               = dpi(20)
theme.menu_width                                = dpi(160)
theme.menu_icon_size                            = dpi(32)
theme.awesome_icon                              = theme.icon_dir .. "/awesome_icon_white.png"
theme.awesome_icon_launcher                     = theme.icon_dir .. "/awesome_icon.png"
theme.taglist_squares_sel                       = theme.icon_dir .. "/square_sel.png"
theme.taglist_squares_unsel                     = theme.icon_dir .. "/square_unsel.png"
theme.spr_small                                 = theme.icon_dir .. "/spr_small.png"
theme.spr_very_small                            = theme.icon_dir .. "/spr_very_small.png"
theme.spr_right                                 = theme.icon_dir .. "/spr_right.png"
theme.spr_bottom_right                          = theme.icon_dir .. "/spr_bottom_right.png"
theme.spr_left                                  = theme.icon_dir .. "/spr_left.png"
theme.bar                                       = theme.icon_dir .. "/bar.png"
theme.bottom_bar                                = theme.icon_dir .. "/bottom_bar.png"
theme.mpdl                                      = theme.icon_dir .. "/mpd.png"
theme.mpd_on                                    = theme.icon_dir .. "/mpd_on.png"
theme.prev                                      = theme.icon_dir .. "/prev.png"
theme.nex                                       = theme.icon_dir .. "/next.png"
theme.stop                                      = theme.icon_dir .. "/stop.png"
theme.pause                                     = theme.icon_dir .. "/pause.png"
theme.play                                      = theme.icon_dir .. "/play.png"
theme.clock                                     = theme.icon_dir .. "/clock.png"
theme.calendar                                  = theme.icon_dir .. "/cal.png"
theme.cpu                                       = theme.icon_dir .. "/cpu.png"
theme.gpu                                       = theme.icon_dir .. "/gpu.png"
theme.net_up                                    = theme.icon_dir .. "/net_up.png"
theme.net_down                                  = theme.icon_dir .. "/net_down.png"
theme.layout_tile                               = theme.icon_dir .. "/tile.png"
theme.layout_tileleft                           = theme.icon_dir .. "/tileleft.png"
theme.layout_tilebottom                         = theme.icon_dir .. "/tilebottom.png"
theme.layout_tiletop                            = theme.icon_dir .. "/tiletop.png"
theme.layout_fairv                              = theme.icon_dir .. "/fairv.png"
theme.layout_fairh                              = theme.icon_dir .. "/fairh.png"
theme.layout_spiral                             = theme.icon_dir .. "/spiral.png"
theme.layout_dwindle                            = theme.icon_dir .. "/dwindle.png"
theme.layout_max                                = theme.icon_dir .. "/max.png"
theme.layout_fullscreen                         = theme.icon_dir .. "/fullscreen.png"
theme.layout_magnifier                          = theme.icon_dir .. "/magnifier.png"
theme.layout_floating                           = theme.icon_dir .. "/floating.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(0)
theme.titlebar_close_button_normal              = theme.default_dir.."/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.default_dir.."/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.default_dir.."/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.default_dir.."/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.default_dir.."/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.default_dir.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.default_dir.."/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.default_dir.."/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.default_dir.."/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.default_dir.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.default_dir.."/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.default_dir.."/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.default_dir.."/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.default_dir.."/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.default_dir.."/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.default_dir.."/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.default_dir.."/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.default_dir.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.default_dir.."/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.default_dir.."/titlebar/maximized_focus_active.png"

theme.musicplr = string.format("%s -e ncmpcpp", awful.util.terminal)

local icomoon = "icomoon 10"
local icomoon_larger = "icomoon 12"
local markup = lain.util.markup
--local accent   = "#9B72CF"
local accent   = "#A790D5"
local active_tag   = "#a0a0a0"
local dim_tag   = "#505050"
local space3 = markup.font("Roboto 3", "   ")
local space2 = markup.font("Roboto 3", "  ")
local space = wibox.widget.textbox(markup.font("Roboto 8", "   "))
local space1 = wibox.widget.textbox(markup.font("Roboto 3", "  "))

-- Notifications
local notifs = {}
notifs.icon = wibox.widget.textbox(markup.font(theme.icon_font .. " Outlined 11", ""))
helpers.ui.add_hover_cursor(notifs.icon, "hand1")
notifs.status = false

theme.notifs = helpers.notifs({
    attach_to = { notifs.icon },
})

notifs.icon:connect_signal("button::press", function(_, _, _, _) 
	notifs.status = not notifs.status
	if notifs.status then
		notifs.icon:set_markup(markup.font(theme.icon_font .. " Rounded 11", ""))
	else
		notifs.icon:set_markup(markup.font(theme.icon_font .. " Outlined 11", ""))
	end
end)

-- Microphone
local microphone = {}

microphone.icon = wibox.widget.textbox(markup.font(theme.icon_font .. "Round 11", ""))
microphone.status = true
helpers.ui.add_hover_cursor(microphone.icon, "hand1")

microphone.icon:connect_signal("button::press", function(_, _, _, _) 
	microphone.status = not microphone.status
	if microphone.status then
		awful.spawn("amixer sset Capture cap", false)
		microphone.icon:set_markup(markup.font(theme.icon_font .. " Round 11", ""))
	else
		awful.spawn("amixer sset Capture nocap", false)
		microphone.icon:set_markup(markup.font(theme.icon_font .. " Round 11", ""))
	end
end)


-- audio

local audio_icon = wibox.widget.textbox(markup.font(theme.icon_font .. "Round 11", ""))
helpers.ui.add_hover_cursor(audio_icon, "hand1")

awesome.connect_signal("mastervolume::update", function()
	awful.spawn.easy_async_with_shell(
	"amixer get Master",
	function(out)
		local _, playback = string.match(out, "([%d]+)%%.*%[([%l]*)")
		if playback == "off" then 
			audio_icon:set_markup(markup.font(theme.icon_font .. "Round 11", ""))
		else
			audio_icon:set_markup(markup.font(theme.icon_font .. "Round 11", ""))
		end
	end)
end)


-- Clock
local mytextclock = wibox.widget.textclock(markup("#A0A0A0", space3 .. space2 .. "%H:%M"))
mytextclock.font = theme.font_light
local clock_icon = wibox.widget.textbox(markup.font(icomoon, ""))
local clockbg = wibox.container.background(mytextclock, theme.bg_focus, gears.shape.rectangle)
local clockwidget = wibox.container.margin(clockbg, dpi(0), dpi(1), dpi(5), dpi(5))

-- Calendar
local mytextcalendar = wibox.widget.textclock(string.format(
	"<span text-transform='uppercase' font='%s' foreground='%s'>%s</span>", 
	theme.font_light, 
	"#A0A0A0", 
	space3 .. space2 .. "%d %b" .. markup.font("Roboto 5", "")
))
local calendar_icon = wibox.widget.textbox(markup.font(theme.icon_font .. " 10", ""))
theme.cal = helpers.cal({
    attach_to = { mytextcalendar },
    icons = "",
    notification_preset = {
        fg = "#A0A0A0",
        bg = theme.bg_normal,
        font = theme.font_light
    }
})

local separator = wibox.widget.textbox(space3 .. markup.fontfg("monospace 8", "#4E4E4E", "🭲") .. space3)

-- MPD
local mpd_icon = wibox.widget.textbox(markup.font(icomoon, ""))
helpers.ui.add_hover_cursor(mpd_icon, "hand1")

mpd_icon:connect_signal("button::press", function(_, _, _, _) 
	awful.spawn.easy_async_with_shell(theme.musicplr, function() end)
end)
local prev_icon = wibox.widget.textbox(markup.font(icomoon_larger, " "))
local next_icon = wibox.widget.textbox(markup.font(icomoon_larger, " "))
local stop_icon = wibox.widget.textbox(markup.font(icomoon_larger, " "))
local pause_icon = wibox.widget.textbox(markup.font(icomoon_larger, ""))
local play_pause_icon = wibox.widget.textbox(markup.font(icomoon_larger, ""))
--
theme.mpd = helpers.playerctl({
    timeout = 0.1,
    settings = function ()
        if playerctl_now.state == "play" then
            play_pause_icon:set_markup(markup.font(icomoon_larger, ""))
        elseif playerctl_now.state == "pause" then
            play_pause_icon:set_markup(markup.font(icomoon_larger, ""))
        else
            play_pause_icon:set_markup(markup.font(icomoon_larger, ""))
        end
    end
})

local musicbg = wibox.container.background(theme.mpd.widget, theme.bg_focus, gears.shape.rectangle)
local musicwidget = wibox.container.margin(musicbg, dpi(0), dpi(0), dpi(5), dpi(5))

musicwidget:buttons(my_table.join(awful.button({ }, 1,
function () awful.spawn(theme.musicplr) end)))
prev_icon:buttons(my_table.join(awful.button({}, 1,
function ()
    os.execute("playerctl previous")
    theme.mpd.update()
end)))
next_icon:buttons(my_table.join(awful.button({}, 1,
function ()
    os.execute("playerctl next")
    theme.mpd.update()
end)))
stop_icon:buttons(my_table.join(awful.button({}, 1,
function ()
    os.execute("playerctl stop")
    theme.mpd.update()
end)))
play_pause_icon:buttons(my_table.join(awful.button({}, 1,
function ()
    os.execute("playerctl play-pause")
    theme.mpd.update()
end)))

-- Battery
local bat = lain.widget.bat({
    settings = function()
        bat_header = " Bat "
        bat_p      = bat_now.perc .. " "
        if bat_now.ac_status == 1 then
            bat_p = bat_p .. "Plugged "
        end
        widget:set_markup(markup.font(theme.font, markup(blue, bat_header) .. bat_p))
    end
})

-- Temp text
local temp_text = wibox.widget.textbox(markup.font(theme.font, "°C"))

-- Net
local font_icon = "Material Icons Round 15"
local net_text = wibox.widget.textbox(markup.font(font_icon, ""))

theme.network = helpers.network({ 
	timeout = 2,
	settings  = function()
	if network_on then
	  	if network_strength == 0 then
	  		net_text:set_markup(markup.font(font_icon, ""))
	  		return
	  	end
	  	if network_strength <= 20 then
	  		net_text:set_markup(markup.font(font_icon, ""))
	  	elseif network_strength <= 40 then
	  		net_text:set_markup(markup.font(font_icon, ""))
	  	elseif network_strength <= 60 then
	  		net_text:set_markup(markup.font(font_icon, ""))
	  	elseif network_strength <= 80 then
	  		net_text:set_markup(markup.font(font_icon, ""))
	  	else
	  		net_text:set_markup(markup.font(font_icon, ""))
	  	end
	  else
	  	net_text:set_markup(markup.font(font_icon, ""))
	  end
	end
})
-- CPU
--
local cpu_icon = wibox.widget.textbox(markup.font(icomoon, "") .. space3 .. markup.font(theme.font_light, "CPU") .. space3)

local cputemp = lain.widget.temp({
  timeout = 5,
  settings = function()
	awful.spawn.easy_async_with_shell("cat /sys/class/hwmon/hwmon1/temp1_input", function(out)
		widget:set_markup(space3 .. markup.font(theme.font, out:match("^%d%d")) .. space3)
	end)
  end
})

-- GPU
local gpu_icon = wibox.widget.textbox(markup.font(icomoon, "") .. space3 .. markup.font(theme.font_light, "GPU") .. space3)
local gputemp = helpers.gputemp({
  timeout = 5,
  settings = function()
	widget:set_markup(space3 .. markup.font(theme.font, gputemp_now) .. space3)
  end
})

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local spr_small = wibox.widget.imagebox(theme.spr_small)
local spr_very_small = wibox.widget.imagebox(theme.spr_very_small)
local spr_right = wibox.widget.imagebox(theme.spr_right)
local spr_bottom_right = wibox.widget.imagebox(theme.spr_bottom_right)
local spr_left = wibox.widget.imagebox(theme.spr_left)
local bar = wibox.widget.imagebox(theme.bar)
local bottom_bar = wibox.widget.imagebox(theme.bottom_bar)

local barcolor  = gears.color({
    type  = "linear",
    from  = { dpi(32), 0 },
    to    = { dpi(32), dpi(32) },
    stops = { {0, theme.bg_focus}, {0.25, "#505050"}, {1, theme.bg_focus} }
})

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.set("#121212")
    --gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[2])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    local taglist_buttons = gears.table.join(
      awful.button({}, 1, function(t)
      	t:view_only()
      end),
      awful.button({ modkey }, 1, function(t)
      	if client.focus then
      		client.focus:move_to_tag(t)
      	end
      end),
      awful.button({}, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
      	if client.focus then
      		client.focus:toggle_tag(t)
      	end
      end),
      awful.button({}, 4, function(t)
      	awful.tag.viewnext(t.screen)
      end),
      awful.button({}, 5, function(t)
      	awful.tag.viewprev(t.screen)
      end)
    )


    s.mytaglist = awful.widget.taglist({
      screen = s,
      filter = awful.widget.taglist.filter.all, 
      layout = wibox.layout.fixed.horizontal,
      widget_template = {
        widget = wibox.container.margin,
	margins = { top = dpi(10), bottom = dpi(10), left = dpi(6), right = dpi(6)},
        forced_width = dpi(35),
        forced_height = dpi(40),
        create_callback = function(self, c3, _)
        	local indicator = wibox.widget({
        		widget = wibox.container.margin,
        		--valign = "center",
        		--halign = "left",
        		{
        			widget = wibox.container.background,
        			shape = gears.shape.rounded_bar,
        		},
        	})

        	self:set_widget(indicator)
        
        	if c3.selected then
        		self.widget.children[1].bg = accent
        		--self.indicator_animation:set(dpi(32))
        	elseif #c3:clients() == 0 then
        		self.widget.children[1].bg = dim_tag
        		--self.indicator_animation:set(dpi(8))
        	else
        		self.widget.children[1].bg = active_tag
        		--self.indicator_animation:set(dpi(16))
        	end
        
        end,
        update_callback = function(self, c3, _)
        	if c3.selected then
        		self.widget.children[1].bg = accent
        	elseif #c3:clients() == 0 then
        		self.widget.children[1].bg = dim_tag
        	else
        		self.widget.children[1].bg = active_tag
        	end
        end,
        },
	buttons = taglist_buttons,
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, { bg_focus = theme.bg_focus, shape = gears.shape.rectangle, shape_border_width = 5, shape_border_color = theme.tasklist_bg_normal, align = "center" })

    -- Systray
    local function system_tray()
      local mysystray = wibox.widget.systray()
      mysystray.base_size = dpi(15)
      
      local widget = wibox.widget({
      	widget = wibox.container.constraint,
      	strategy = "max",
      	width = dpi(0),
      	{
      		widget = wibox.container.margin,
      		margins = dpi(8),
      		mysystray,
      	},
      })
      
      local arrow = wibox.widget.textbox(markup.font("Material Icons Round 12", ""))
      helpers.ui.add_hover_cursor(arrow, "hand1")

      arrow.is_open = false

      arrow:connect_signal("button::press", function(_, _, _, _) 
	      if arrow.is_open then
              	widget.width = 0
                arrow:set_markup(markup.font("Material Icons Round 12", ""))
		arrow.is_open = false
	      else
              	widget.width = 400
	        arrow:set_markup(markup.font("Material Icons Round 12", ""))
		arrow.is_open = true
	      end

      end)
      return wibox.widget({
      	layout = wibox.layout.fixed.horizontal,
      	arrow,
      	widget,
      })
    end

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(32) })

    audio_icon:connect_signal("button::press", function() 
	    awesome.emit_signal("playerctlvolume::update", s)
	    awesome.emit_signal("mastervolume::update", s)
	    awesome.emit_signal("volumepanel::toggle", s)
    end)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
	    {
	      {
		{
		  layout = wibox.layout.fixed.horizontal,
		  space,
    	          s.mytaglist,
		  space,
		},
	        bg     = '#303030',
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 2)
                end,
	        widget = wibox.container.background,
              },
	      top = 5,
	      bottom = 5,
	      left = 5,
	      right = 1,
	      widget = wibox.container.margin,
	    },
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --wibox.widget.systray(),
	    separator,
	    system_tray(),
	    space1,
	    space1,
	    space1,
	    {
	      {
		{
		  layout = wibox.layout.fixed.horizontal,
		  space,
		  net_text,
		  separator,
                  gpu_icon,
                  gputemp,
                  temp_text,
		  separator,
                  cpu_icon,
                  cputemp,
	          temp_text,
		  separator,
                  calendar_icon,
                  mytextcalendar,
		  separator,
                  clock_icon,
                  clockwidget,
		  separator,
                  prev_icon,
                  next_icon,
                  stop_icon,
                  play_pause_icon,
		  space1,
		  separator,
                  mpd_icon,
		  separator,
		  microphone.icon,
		  separator,
		  audio_icon,
		  separator,
		  notifs.icon,
		  separator,
                  s.mylayoutbox,
		  space,
		},
	        bg     = '#303030',
                shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 2)
                end,
	        widget = wibox.container.background,
              },
	      top = 5,
	      bottom = 5,
	      left = 1,
	      right = 5,
	      widget = wibox.container.margin,
	    },
        },
    }
end

return theme
