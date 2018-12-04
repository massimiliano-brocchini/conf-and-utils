-- show notification
function alert (testo,timeout,options)
	local args = { text = testo , screen = mouse.screen , timeout = timeout or 0 , hover_timeout = 0 }
	if type(options) == "table" then 
		args = awful.util.table.join(args,options) 
	end
	return naughty.notify (args)
end


-- print_r for lua tables (similar to PHP print_r)
function print_r (t)
	alert(_pr_r(t))
end


-- show current layout name (to be userd with mouse enter/leave events on layout widget)
layout_notification = {}
function layout_name_show(timeout) 
	local s = mouse.screen
	layout_notification[s]=alert( awful.layout.getname(awful.layout.get(s)) , timeout ) 
end


function layout_name_hide()
	for s in screen do
		if layout_notification[s.index] ~= nil then 
			naughty.destroy(layout_notification[s.index]) 
			layout_notification[s.index]=nil 
		end 
	end
end
