function layouts_menu()
	local ll = {}
	for i,l in pairs(layouts) do
		ll[i] = { l.name ,
			function ()
				awful.layout.set(layouts[i])
			end
		, beautiful['layout_'..l.name]}
	end
	lmenu = awful.menu({items = ll, theme = {width = 80}})
	lmenu:toggle({keygrabber = true})
end

function tags_per_layout()
	local label = nil
	local max_len = 0
	local ll = {}
	local ll_tags = {}
	local s = mouse.screen

	for s = 1, screen.count() do
		table.insert(ll, {" -- Screen "..s.." -- "})

		for i,l in pairs(layouts) do
			ll_tags[l.name]={}
		end
		for j,t in pairs(tags[s]) do
			table.insert(ll_tags[awful.tag.getproperty(t,'layout').name],j)
		end

		for i,l in pairs(layouts) do
			if next(ll_tags[l.name]) ~= nil then
				label = l.name.." "..table.concat(ll_tags[l.name],',')
				max_len=math.max(max_len,label:len()) 
				table.insert(ll,{ label,
					function ()
						mouse.screen = s
						mouse.coords({x=center('x'),y=center('y')})
						awful.tag.viewonly(tags[s][ll_tags[l.name][1]])
					end
				, beautiful['layout_'..l.name]})
			end
		end

	end
	local tmenu = awful.menu({items = ll, theme = {width = max_len * theme.fontsize}})
	tmenu:toggle({keygrabber = true})
end

function clients_menu()
	local clients = {}
	for i, c in pairs(client.get()) do

		if not c.skip_taskbar then 

			if c.class == "Firefox" then
				icon = icons.firefox
			elseif c.class == "Galculator" then
				icon = icons.galculator
			else
				icon = c.icon
			end

			clients[i] = { awful.util.escape(c.name) or "",
				function()
					awful.tag.viewonly(c:tags()[1])
					client.focus = c
					mouse.screen = c.screen
					mouse.coords({x=center('x'),y=center('y')})
					c:raise()
					end
			, icon}
		end
	end
	if next(clients) ~= nil then 
		local m = awful.menu({items = clients , theme = {width = 350}})
		m:toggle({keygrabber = true})
		return m
	end
end


function terminals_menu()
	local terms = {}
	for i, c in pairs(client.get()) do
		if c.class == 'Roxterm' then
			terms[i] = { awful.util.escape(c.name) or "",
				function()
					awful.tag.viewonly(c:tags()[1])
					client.focus = c
					mouse.screen = c.screen
					mouse.coords({x=center('x'),y=center('y')})
					c:raise()
					end
			, icons.roxterm}
		end
	end
	if next(terms) == nil then return end
	local m = awful.menu({items = terms, theme = {width = 500}})
	m:toggle({keygrabber = true})
end
--- }}}

--- {{{ firefox open tabs (requires tab-selector FF extension! )
function tabs_menu ()
	local is_firefox_running = false
	local ff_windows = {}
	local ff_tabs = {}
	local l = {}
	local title_len = 0
	local url_len = 0
	local px_ratio = 0.92

	for i, c in pairs(client.get()) do
		if c.class == 'Firefox' then
			is_firefox_running = true
			ff_windows[i]=c
		end
	end

	if not is_firefox_running then return end

	local prev_win=nil
	local active_tab=nil
	for _,line in pairs(file('/tmp/tab-selector-'..ff_profile)) do
		for win_num, tab_num, title, url, active in string.gmatch(line,"(%w+)|") do

			if win_num ~= prev_win then
				table.insert(ff_tabs,{ '-- ' .. win_num .. ' --'})
				prev_win = win_num
			end

			if active then 
				active_tab = title
			end

			l[tab_num] = { title = title , url = url }
			title_len  = math.max(title_len , title:len())
			url_len    = math.max(url_len   , url:len())
		end
	end

	for tab_num, label in pairs(l) do
		table.insert(ff_tabs,{ 
			string.format('%-'.. title_len ..'s',label.title) .. " | " .. label.url ,
			function () 
				local c = nil
				for key, value in pairs(ff_windows) do
					if trim(value.name)==trim(active_tab)..' - Mozilla Firefox' then
						c=value
					end
				end
				if c == nil then return end

				--[[ this can be userd instead of xdotool preceded by a sleep
				local ct=0
				local select_tab 
				select_tab = function(c)
					if ct < 1 then --on my PCs two "refresh" events are necessary to make sure firefox receives the keystrokes
						ct=ct+1
					else 
						ct=0
					for i = 1 , string.len(tab_num) do
						local code = string.sub(tab_num,i,1)
						if code == '0' then code = 19 else code = 9 + code end -- keycodes for numbers are from 10 to 19
						root.fake_input("key_press",code);root.fake_input("key_release",code)
					end
					awesome.disconnect_signal('refresh', select_tab)
					end
				end
				local select_tab_on_focus
				select_tab_on_focus = function (c)
					c:disconnect_signal('focus', select_tab_on_focus)
					awesome.connect_signal('refresh', select_tab)
				end
				c:connect_signal('focus', select_tab_on_focus)
				--]]

				awful.tag.viewonly(c:tags()[1])
				client.focus = c
				mouse.screen = c.screen
				mouse.coords({x=center('x'),y=center('y')})
				c:raise()
				awful.util.spawn('zsh -c "sleep 0.2; xdotool getactivewindow key --clearmodifiers --delay 2 ctrl+shift+x type --delay 2 ' .. tab_num ..'"&')
			end
			, icons.firefox }
		)
	end

	-- local ff_tabs_menu = awful.menu({items = ff_tabs, theme = {width = max_len * theme.fontsize}})
	local ff_tabs_menu = awful.menu({items = ff_tabs, theme = {width = math.floor((url_len + title_len)*theme.fontsize*px_ratio) , font = 'monospace '..theme.fontsize }}) 
	ff_tabs_menu:toggle({keygrabber = true})
end
