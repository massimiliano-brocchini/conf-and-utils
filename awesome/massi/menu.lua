function layouts_menu()
	local ll = {}
	for i,l in pairs(awful.layout.layouts) do
		ll[i] = { l.name ,
			function ()
				awful.layout.set(awful.layout.layouts[i])
			end
		, beautiful['layout_'..l.name]}
	end
	lmenu = awful.menu({items = ll, theme = {width = 10*beautiful.fontsize}})
	lmenu:toggle({keygrabber = true})
end

function tags_per_layout()
	local label = nil
	local max_len = 0
	local ll = {}
	local ll_tags = {}
	local s = mouse.screen

	for s in screen do
		table.insert(ll, {" -- Screen "..s.index.." -- "})

		for i,l in pairs(awful.layout.layouts) do
			ll_tags[l.name]={}
		end
		for j,t in pairs(s.tags) do
			table.insert(ll_tags[awful.tag.getproperty(t,'layout').name],j)
		end

		for i,l in pairs(awful.layout.layouts) do
			if next(ll_tags[l.name]) ~= nil then
				label = l.name.." "..table.concat(ll_tags[l.name],',')
				max_len=math.max(max_len,label:len()) 
				table.insert(ll,{ label,
					function ()
						mouse.screen = s
						mouse.coords({x=center('x'),y=center('y')})
						awful.tag.viewonly(s.tags[ll_tags[l.name][1]])
					end
				, beautiful['layout_'..l.name]})
			end
		end

	end
	local tmenu = awful.menu({items = ll, theme = {width = max_len * beautiful.fontsize}})
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
		local m = awful.menu({items = clients , theme = {width = 65 * beautiful.fontsize}})
		m:toggle({keygrabber = true})
		return m
	end
end


function terminals_menu()
	local terms = {}
	for i, c in pairs(client.get()) do
		if c.class == 'Sakura' then
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
	local m = awful.menu({items = terms, theme = {width = 65 * beautiful.fontsize}})
	m:toggle({keygrabber = true})
end
--- }}}
