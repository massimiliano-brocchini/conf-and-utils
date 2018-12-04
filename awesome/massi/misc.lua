-- paste plain text
function paste_senza_formattazione()
	awful.util.spawn_with_shell(awful.util.getdir("config") .. "/paste_senza_formattazione.sh " .. client.focus.window)
end


function inhibit_screensaver(c)
    local timer = timer { timeout = 240 }
    timer:connect_signal("timeout", function()
										root.fake_input("key_press"   , 37)
										root.fake_input("key_release" , 37)  -- CTRL
									end)
    timer:start()
	c:connect_signal('unmanage', function() timer:stop() end)
end


function touchpad_toggle(t)
	local t = t or trim(awful.util.pread('xinput list | grep "PS/2 Generic Mouse" | cut -f 2 | cut -c 4-'))
	local touchpad = trim(awful.util.pread('xinput --list-props '.. t ..' | grep "Device Enabled" | cut -c 24')) == '1'
	if touchpad then
		awful.util.spawn('xinput set-prop '.. t ..' "Device Enabled" 0')
		tpn = naughty.notify({ text='TOUCHPAD OFF', fg='#FF0000', screen = mouse.screen, timeout = 0})
	else
		awful.util.spawn('xinput set-prop '.. t ..' "Device Enabled" 1')
		naughty.destroy(tpn)
	end
end

-- {{{ funzione per Shift + ESC
function close_everything()
	local s = mouse.screen

	for _ , pos in pairs(naughty.notifications[s.index]) do
		for _ , notification in pairs(awful.util.table.reverse(pos)) do
			naughty.destroy(notification)
		end
	end

	--- {{{ menu'
	-- client aperti
	if cmenu and cmenu.hide then cmenu:hide() end
	-- layouts
	if lmenu and lmenu.hide then lmenu:hide() end
	-- principale
	if mymainmenu.hide then mymainmenu:hide() end
	--- }}}

	-- nome del layout scelto
	layout_name_hide()

	-- {{{ calendario
--	remove_calendar()
--	if calendar_click then
--		calendar_click = false
--		mytextclock:connect_signal("mouse::leave", remove_calendar)
--	end
	-- }}}
end
-- Menu da gestire dentro close_everything devono essere definiti globali
cmenu = nil
lmenu = nil
-- }}}
