--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local wibox    = require("wibox")
local awful    = require("awful")
local markup    = require("lain.util.markup")
local tonumber = tonumber

local function factory(args)
    args           = args or {}

    local net_stat  = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 30
    local font = "Material Icons Round 15"
    local settings = args.settings or function() end

    function net_stat.update()
	local get_status = [[sh -c "nmcli g | tail -n 1 | awk '{ print $1 }'"]]
	network_on = false
	network_strength = 0
        awful.spawn.easy_async(get_status, function(out)
	    net_ssid = string.gsub(out, "^%s*(.-)%s*$", "%1")
	    if not net_ssid:match("disconnected") then
		network_on = true
		local getstrength = [[ awk '/^\s*w/ { print  int($3 * 100 / 70) }' /proc/net/wireless ]]
		awful.spawn.easy_async_with_shell(getstrength, function(stdout)
			if not tonumber(stdout) then
				network_strength = 0
				widget = net_stat.widget
				settings()
				return
			end
			local strength = tonumber(stdout)
			if strength <= 20 then
				network_strength = 20
			elseif strength <= 40 then
				network_strength = 40
			elseif strength <= 60 then
				network_strength = 60
			elseif strength <= 80 then
				network_strength = 80
			else
				network_strength = 100
			end
		end)
            else
		network_on = false
            end

            widget = net_stat.widget
	    settings()
        end)
    end

    helpers.newtimer("networkstatus", timeout, net_stat.update)

    return net_stat
end

return factory
