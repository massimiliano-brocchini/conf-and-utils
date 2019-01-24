-- card must be a string in the following format: '-c X'
function volume(v,channel,card)
	local card = card or "";
	local channel = channel or "Master"

	awful.util.spawn(" amixer ".. card .." set ".. channel .." ".. v .." unmute &")
	update_volume_widget(channel,card)
end

-- card must be a string in the following format: '-c X'
function mute_toggle(channel,card)
	local card = card or "";
	local channel = channel or "Master"

	awful.util.spawn("amixer ".. card .." set ".. channel .." toggle") 
	volume_is_muted = trim(awful.util.pread("amixer ".. card .." -M get ".. channel .." | tail -1 | egrep -o '[a-z]+' | tail -1")) == 'off' 
	if volume_is_muted then
		msg = "MUTE"
	end
	update_volume_widget(channel,card)
end

function loudness_toggle(card)
	local card = card or "";
	local channel = "Loudness"

	awful.util.spawn("amixer ".. card .." set ".. channel .." toggle") 
	loudness_is_muted = trim(awful.util.pread("amixer ".. card .." -M get ".. channel .." | tail -1 | egrep -o '[a-z]+' | tail -1")) == 'on' 
	if loudness_is_muted then
		msg = "LOUD"
	end
	update_volume_widget('PCM',card)
end

function get_channel_info(channel, card)
	local card = card or "";
	local channel = channel or "Master"

	local fd = io.popen("amixer " .. card .. " -M -- sget " .. channel)
	local info = fd:read("*all")
	fd:close()

	return info
end


function update_volume_widget(channel, card, osd)
	local osd    = osd or true
	local info   = get_channel_info(channel, card)
	local volume = string.match(info, "(%d?%d?%d)%%")
	if not volume then return end
	volume = trim(string.format("% 3d", volume))
	
	local status = string.match(info, "%[(o[^%]]*)%]")
	
	local loud = ""
	if hostname == "x121e" then
		info 		 = get_channel_info('Loudness', card)
		local l   = string.match(info, "%[(o[^%]]*)%]")
		if string.find(l, "on", 1, true) then
			loud = "<span foreground=\"#00ffff\">L</span>" 
		end
	end

	if msg ~= "" then
		if osd then 
			alert(msg,1,{fg = '#FF0000'})
		end
	end

	if string.find(status, "on", 1, true) then
		if osd then
			vol_alert = vol_alert or {}
			vol_alert.id = vol_alert.id or 0
			vol_alert = alert(volume,1,{fg = '#00FF00' , replaces_id = vol_alert.id , font = beautiful.font_type.." "..beautiful.fontsize+4})
		end
		volume = " v." .. volume .. loud .. "% "
	else -- MUTE
		volume = " v." .. volume .. loud .. "<span foreground=\"#ff0000\">M</span> "
	end

	msg = ""

	myvolume:set_markup(volume)
end
