local mode = nil

telecomando_keys = awful.util.table.join(

	-- TV on/off
	awful.key({ "Control" }, "t",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				if trim(awful.util.pread('xset q | grep "Monitor is Off" > /dev/null')) == '' then
					awful.util.spawn_with_shell('touch /tmp/force_monitor_sleep ; xset dpms force off ; $HOME/bin/watchdog_heartbeat_dpms.sh &')
				end
			end
		end),

	-- PC on/off	
	awful.key({ "Mod1" }, "F4",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",24);root.fake_input("key_release",24)  -- Q
			elseif client.focus and (client.focus.class=="vlc" or client.focus.class=="audacious") then
				root.fake_input("key_press",37);root.fake_input("key_press",24);root.fake_input("key_release",24);root.fake_input("key_release",37)  -- CTRL + Q
			end
		end),

	-- Video
	awful.key({ "Control" }, "e",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",32);root.fake_input("key_release",32) -- O
			elseif client.focus and client.focus.class=="Vlc" then
				root.fake_input("key_press",28);root.fake_input("key_release",28) -- T
			end
		end),

	-- Music
	awful.key({ "Control" }, "m",
		function ()
			local clients = {}
			for c in next(client.get()) do
				if c.class == "Audacious" then
						awful.tag.viewonly(c:tags()[1])
						client.focus = c
						mouse.screen = c.screen
						mouse.coords({x=center('x'),y=center('y')})
						c:raise()
						return
				end
			end
			awful.util.spawn("audacious")
		end)

	-- Picture	
	awful.key({ "Control" }, "i",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				if mode == 'picture' then 
					os.execute("killall -q osd_cat")
					mode = nil
				else
					os.execute("killall -q osd_cat")
					awful.util.spawn_with_shell("echo 'picture - left/right: brightness  ,  up/down: contrast' | osd_cat --color=green --align=center --pos=bottom --delay=0 --age=0 --offset=-95 --font='-*-courier-*-*-*-*-34-*-*-*-*-*-*-*'")
					mode = 'picture'
				end
			end
		end

	-- MyTV
	awful.key({ "Control" , "Shift" }, "t",

	-- More
	awful.key({ }, "Menu",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",32);root.fake_input("key_release",32) -- O
			elseif client.focus and client.focus.class=="Vlc" then
				root.fake_input("key_press",28);root.fake_input("key_release",28) -- T
			end
		end),

	-- RTV
	awful.key({ "Control" }, "o",

	-- DVD
	awful.key({ "Control" , "Shift" }, "m",

	-- Guide
	awful.key({ "Control" }, "g",

	-- Radio
	awful.key({ "Control" }, "a",

	-- Start
	awful.key({ modkey , "Mod1" }, "Return",

	-- CH/PG +
	awful.key({ }, "Prior",
		function ()
			root.fake_input("key_press",117);root.fake_input("key_release",117) -- PGUP
		end),

	-- CH/PG -
	awful.key({ }, "Next",
		function ()
			root.fake_input("key_press",112);root.fake_input("key_release",112) --PGDWN 
		end),

	-- REW
	awful.key({ "Control" , "Shift" }, "b",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",117);root.fake_input("key_release",117) --PGDWN 
			elseif then

			end
		end),

	-- FWD
	awful.key({ "Control" , "Shift" }, "f",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",112);root.fake_input("key_release",112) --PGUP 
			elseif then

			end
		end),

	-- REPLAY
	awful.key({ "Control" }, "b",

	-- SKIP
	awful.key({ "Control" }, "f",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",60);root.fake_input("key_release",60) -- . (punto) 
			elseif then

			end
		end),

	-- PLAY
	awful.key({ "Control" , "Shift" }, "p",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",65);root.fake_input("key_release",65) -- SPACE 
			elseif then

			end
		end),

	-- PAUSE
	awful.key({ "Control" }, "p",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",65);root.fake_input("key_release",65)  
			elseif then

			end
		end),

 	-- STOP
	awful.key({ "Control" , "Shift" }, "s",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",24);root.fake_input("key_release",24) -- Q
			elseif then

			end
		end),

	-- RECORD
	awful.key({ "Control" }, "r",

	-- AUDIO
	awful.key({ "Control" , "Shift" }, "a",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				if mode == 'audio' then 
					os.execute("killall -q osd_cat")
					mode = nil
				else
					os.execute("killall -q osd_cat")
					awful.util.spawn_with_shell("echo audio | osd_cat --color=green --align=center --pos=bottom --delay=0 --age=0 --offset=-95 --font='-*-courier-*-*-*-*-34-*-*-*-*-*-*-*'")
					mode = 'audio'
				end
			end
		end),

	-- TITLE
	awful.key({ "Control" }, "u",
		function ()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				root.fake_input("key_press",55);root.fake_input("key_release",55) -- V
			elseif then

			end
		end),

	-- ASPECT
	awful.key({ "Control" , "Shift" }, "z",
		function()
			if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
				if mode == 'aspect' then 
					os.execute("killall -q osd_cat")
					mode = nil
				else
					os.execute("killall -q osd_cat")
					awful.util.spawn_with_shell("echo aspect | osd_cat --color=green --align=center --pos=bottom --delay=0 --age=0 --offset=-95 --font='-*-courier-*-*-*-*-34-*-*-*-*-*-*-*'")
					mode = 'aspect'
				end
			end
		end),

	-- MSN
	awful.key({ "Control" }, "n",

	-- HELP
	awful.key({ }, "F1",


	awful.key({ }, "Left",
		function()
			if mode == 'audio' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then

				elseif then

				end
			elseif mode == 'aspect' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",25);root.fake_input("key_release",25) -- W
				elseif then

				end
			elseif mode == 'picture' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",12);root.fake_input("key_release",12) -- 3
				elseif then

				end
			else
				root.fake_input("key_press",113);root.fake_input("key_release",113)
			end
		end),
	awful.key({ }, "Right",
		function()
			if mode == 'audio' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then

				elseif then

				end
			elseif mode == 'aspect' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",26);root.fake_input("key_release",26) -- E
				elseif then

				end
			elseif mode == 'picture' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",13);root.fake_input("key_release",13) -- 4
				elseif then

				end
			else
				root.fake_input("key_press",114);root.fake_input("key_release",114)
			end
		end),
	awful.key({ }, "Up",
		function()
			if mode == 'audio' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then

				elseif then

				end
			elseif mode == 'aspect' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",26);root.fake_input("key_release",26) -- E
				elseif then

				end
			elseif mode == 'picture' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",11);root.fake_input("key_release",11) -- 2
				elseif then

				end
			else
				root.fake_input("key_press",111);root.fake_input("key_release",111)
			end
		end),
	awful.key({ }, "Down",
		function()
			if mode == 'audio' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then

				elseif then

				end
			elseif mode == 'aspect' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",25);root.fake_input("key_release",25) -- W
				elseif then

				end
			elseif mode == 'picture' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",10);root.fake_input("key_release",10) -- 1
				elseif then

				end
			else
				root.fake_input("key_press",116);root.fake_input("key_release",116)
			end
		end),
	awful.key({ }, "Return",
		function()
			if mode == 'audio' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then
					root.fake_input("key_press",108);root.fake_input("key_press",48);root.fake_input("key_release",48);root.fake_input("key_release",108) -- # (layout ITA)
				elseif then

				end
			elseif mode == 'aspect' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then

				elseif then

				end
			elseif mode == 'picture' then
				if client.focus and (client.focus.class=="MPlayer" or client.focus.class=="Smplayer" or client.focus.class=="mplayer2") then

				elseif then

				end
			else
				root.fake_input("key_press",36);root.fake_input("key_release",36)
			end
		end),
)
