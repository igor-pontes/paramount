local naughty = require("naughty")
local playerctl_daemon = require("signal.playerctl")

local is_playing = false

playerctl_daemon:connect_signal("playback_status", function(_, playing, _)
	if playing then
		is_playing = true
	else
		is_playing = false
	end
end)

playerctl_daemon:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	if new == true and is_playing then
		naughty.notify({
			app_name = "MUSIC",
			title = title,
			text = artist,
			image = album_path,
		})
	end
end)
