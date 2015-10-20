function _pr_r (t, name, indent)
  local tableList = {}
  function table_r (t, name, indent, full)
	local id = not full and name
		or type(name)~="number" and tostring(name) or '['..name..']'
	local tag = indent .. id .. ' = '
	local out = {}	-- result
	if type(t) == "table" then
	  if tableList[t] ~= nil then table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')
	  else
		tableList[t]= full and (full .. '.' .. id) or id
		if next(t) then -- Table not empty
		  table.insert(out, tag .. '{')
		  for key,value in pairs(t) do 
			table.insert(out,table_r(value,key,indent .. '|  ',tableList[t]))
		  end 
		  table.insert(out,indent .. '}')
		else table.insert(out,tag .. '{}') end
	  end
	else 
	  local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)
	  table.insert(out, tag .. val)
	end
	return table.concat(out, '\n')
  end
  return table_r(t,name or 'Value',indent or '')
end


function debug(x,filename)
	local filename = filename or "awesome_debug"
	local f = io.open("/tmp/"..filename, "w")
	f:write(_pr_r(x))
	f:close()
end


function trim(s)
  return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

-- {{{ read file content line by line and store it in a table
function file(f)
	local lines={}
	local i=1
	local fh=io.open(f,"r")
	for l in fh:lines() do
		lines[i]=l
		i=i+1
	end
	fh:close()
	return lines
end
-- }}}

