--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ
      * (c) 2010, Adrian C. <anrxc@sysphere.org>

--]]

local helpers  = require("lain.helpers")
local gears    = require("gears")
local shell    = require("awful.util").shell
local escape_f = require("awful.util").escape
local focused  = require("awful.screen").focused
local naughty  = require("naughty")
local wibox    = require("wibox")
local general_playerctl_daemon = require("signal.playerctl")
local os       = os
local string   = string

-- MPD infos
-- lain.widget.mpd

local function factory(args)
    args                = args or {}

    local playerctl = { widget = args.widget or wibox.widget.textbox() }
    local timeout   = args.timeout or 1
    local settings  = args.settings or function() end

    playerctl_now = {
        state        = "N/A",
        title        = "N/A",
        artist       = "N/A",
        cover        = "N/A",
    }

    local playerctl_daemon = general_playerctl_daemon
    playerctl_daemon:connect_signal("playback_status", function(_, playing)
        gears.debug.print_error(playing)
    	if playing then
    		playerctl_now.state = "play"
    	else
    		playerctl_now.state = "pause"
    	end
    end)

    
    playerctl_daemon:connect_signal("metadata", function(_, title, artist, cover, __, ___, ____)
      if title == "" then
      	playerctl_now.title = "N/A"
      end
      if artist == "" then
      	playerctl_now.artist = "N/A"
      end
      if cover == "" then
      	playerctl_now.cover = gears.filesystem.get_configuration_dir() .. "theme/assets/no_music.png"
      end

      playerctl_now.title  = title
      playerctl_now.artist = artist
      playerctl_now.cover  = cover

    end)

    function playerctl.update()
        widget = playerctl.widget
        settings()
    end

    playerctl.timer = helpers.newtimer("playerctl", timeout, playerctl.update, true, true)

    return playerctl
end

return factory
