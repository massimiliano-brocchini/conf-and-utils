function center(axis)
	local g = screen[mouse.screen].geometry
	if axis=='x' then return g.x + math.floor(g.width / 2)
	else return  g.y + math.floor(g.height / 2) end
end

-- move all the clients of a tag to anoter tag and/or screen (moves all clients tagged with the first tag of the selected client)
function move_tag_content(s,t,c)
	local sel = c or client.focus
	local scr = s or sel.screen 

	local current_tag = sel:tags()[1] 

	local tags=screen[sel.screen]:tags()
	local index=1
	for k, v in pairs(tags) do
		if v == current_tag then index=k end
	end
	index = t or index

	local target = screen[scr]:tags()[index]
	for k, v in pairs(current_tag:clients()) do
		awful.client.movetotag(target,v)
	end
end

-- closes all clients in a tag (see move_tag_content comment for details)
function close_tag_content()
	local sel = client.focus
	local current_tag = sel:tags()[1] 

	for k, v in pairs(current_tag:clients()) do
		v:kill()
	end
end

-- adapted from http://awesome.naquadah.org/wiki/Autostart 
function run_once(prg,arg_string,screen)
    if not prg then
        do return nil end
    end
    if not arg_string then 
		awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. " &)",screen)
	else
		awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. " " .. arg_string .. " &)",screen)
	end
end
