--[[

     Licensed under GNU General Public License v2
      * (c) 2018, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local markup   = require("lain.util.markup")
local awful    = require("awful")
local os       = os
local pairs    = pairs

local function factory(args)
    args = args or {}

    local notifs = {
        attach_to           = args.attach_to or {},
    }

    function notifs.press() 
        awesome.emit_signal("notifs::toggle", awful.screen.focused()) 
    end

    function notifs.attach(widget)
        widget:connect_signal("button::release", notifs.press)
    end

    for _, widget in pairs(notifs.attach_to) do notifs.attach(widget) end

    return notifs
end

return factory

