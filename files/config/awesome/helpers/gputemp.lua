--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local wibox    = require("wibox")
local awful    = require("awful")
local tonumber = tonumber

local function factory(args)
    args           = args or {}

    local gputemp  = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 30
    local settings = args.settings or function() end

    function gputemp.update()
        awful.spawn.easy_async({"nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader"}, function(out)
            gputemp_now = out
            widget = gputemp.widget
            settings()
        end)
    end

    helpers.newtimer("gputhermal", timeout, gputemp.update)

    return gputemp
end

return factory
