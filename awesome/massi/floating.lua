-- position floating client inside the coordinates of a screen
--  0 , 0 = upper left corner of the screen
-- -1 ,-1 = lower right corner of the screen
function position_inside_screen(c, x, y)
	local w = screen[c.screen].geometry
	local g = c.geometry(c)
	if x < 0 then x = w.width  + x - g.width end
	if y < 0 then y = w.height + y - g.height end
	return awful.client.moveresize(x - (g.x - w.x),y - (g.y - w.y),0,0,c)
end


-- set floating client "internal" size 
function absolute_size(c, w, h)
	local g = c.geometry(c)
	return awful.client.moveresize(0, 0, w - g.width, h - g.height, c)
end
