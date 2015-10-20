-- Standard awesome library
local gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")

-- Widgets
vicious = require("vicious")

-- {{{ customizations and extensions by Massi
require("massi.lang")
JSON = require("massi.JSON")
-- {{{ configuration
ff_profile = string.sub(trim(awful.util.pread("grep 'Path=' $HOME/.mozilla/firefox/profiles.ini | head -n 1")),6)
conf_dir   = awful.util.getdir('config')
hostname   = trim(awful.util.pread('hostname'))
username   = trim(awful.util.pread('whoami'))
msg        = ""
beautiful.init(conf_dir..'/theme/theme.lua')
-- }}}
require("massi.wm")
require("massi.notifications")
require("massi.menus")
require("massi.audio")
require("massi.prompts")
require("massi.floating")
require("massi.misc")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

terminal   = "roxterm"
editor     = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey     = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
else
	gears.wallpaper.set("#000000")
end

-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
if hostname == "salotto" then 
	default_layout = layouts[7] -- max
else
	default_layout = layouts[6] -- fair horizontal
end

for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, default_layout) 
end
-- }}}


-- {{{ Menu
icons = { firefox    = conf_dir..'/icons/firefox.png' ,
		  roxterm    = conf_dir..'/icons/roxterm.png' ,
		  leafpad    = conf_dir..'/icons/leafpad.png' ,
		  pcmanfm    = conf_dir..'/icons/pcmanfm.png' ,
		  spacefm    = conf_dir..'/icons/spacefm.png' ,
		  galculator = conf_dir..'/icons/galculator.png' ,
}

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
									{ "&roxterm",  terminal , icons.roxterm },
									{ "&firefox", "firefox" , icons.firefox },
									{ "&leafpad", "leafpad" , icons.leafpad },
									{ "&pcmanfm", "pcmanfm" , icons.pcmanfm },
									{ "&spacefm", "spacefm" , icons.spacefm },
									{ "&galculator", "galculator" , icons.galculator },
								  }
						})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  -- c.minimized = true --MASSI
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts,  1) ; layout_name_hide() ; layout_name_show() end),
                           awful.button({ }, 2, function () if lmenu and lmenu.hide then lmenu:hide(); lmenu=nil else layouts_menu() end 		end), -- Massi
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) ; layout_name_hide() ; layout_name_show() end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts,  1) ; layout_name_hide() ; layout_name_show() end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) ; layout_name_hide() ; layout_name_show() end)))

	layout_notification[s] = nil
	mylayoutbox[s]:connect_signal("mouse::enter", function () layout_name_show() end)
	mylayoutbox[s]:connect_signal("mouse::leave", function () layout_name_hide() end)
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

	-- Volume widget
	myvolume = wibox.widget.textbox()
	if hostname == "x121e" then
		update_volume_widget('PCM')
	end

	-- Battery widget
	if hostname == "x121e" then
		mybattery = wibox.widget.textbox()
		vicious.register(mybattery, vicious.widgets.bat, "[$2% $3h]" , 123, "BAT1")
	end

	if hostname == "h7-25" then
		mybattery = wibox.widget.textbox()
		vicious.register(mybattery, vicious.widgets.bat, "[$2% $3h]" , 123, "BAT0")
	end

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    if screen.count() > 1 then 
		if s == 2 then right_layout:add(wibox.widget.systray()) end
	else 
		right_layout:add(wibox.widget.systray()) 
	end

    right_layout:add(myvolume)
    if hostname == "x121e" or hostname == "h7-25" then right_layout:add(mybattery) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])


    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

-- {{{ Massi: multimedia keys
if hostname == "x121e" then 
	globalkeys = awful.util.table.join(
		awful.key({ }, "XF86AudioRaiseVolume",        function () volume('1+','PCM')    end),
		awful.key({ }, "XF86AudioLowerVolume",        function () volume('1-','PCM')    end),
		awful.key({ }, "XF86AudioMute",         	  function () mute_toggle('PCM')    end),
		awful.key({ }, "XF86WLAN",         	  		  function () loudness_toggle()     end),
		awful.key({ }, "XF86Display",		          function () touchpad_toggle('12') end)
	)
else
	globalkeys = awful.util.table.join(
		awful.key({ }, "XF86AudioRaiseVolume",        function () volume('2+')          end),
		awful.key({ }, "XF86AudioLowerVolume",        function () volume('2-')          end),
		awful.key({ }, "XF86AudioMute",         	  function () mute_toggle()         end),
		awful.key({modkey }, "F12",         		  function () volume('2+')          end),
		awful.key({modkey }, "F11",         		  function () volume('2-')          end),
		awful.key({modkey }, "F10",         		  function () mute_toggle()         end),
		awful.key({ }, "XF86TouchpadToggle",          function () touchpad_toggle() end)
	)
end
if hostname == "salotto--" then
	local telecomando = require("telecomando")
	globalkeys = awful.util.table.join(globalkeys,telecomando.telecomando_keys)
end
-- }}}

globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
	--
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(-1) ; mouse.coords({x=center('x'),y=center('y')}) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) ; mouse.coords({x=center('x'),y=center('y')}) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Control" }, "r", 		  awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", 		  awesome.quit),
    awful.key({ modkey,           }, "Return",	  function () awful.util.spawn(terminal)    end),
    awful.key({ modkey,           }, "l",     	  function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     	  function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     	  function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     	  function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     	  function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     	  function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space",     function () awful.layout.inc(layouts,  1) ; layout_name_hide() ; layout_name_show(2) end),
    awful.key({ modkey, "Shift"   }, "space",     function () awful.layout.inc(layouts, -1) ; layout_name_hide() ; layout_name_show(2) end),
    -- {{{ Massi
    awful.key({ "Shift"           }, "Escape",    close_everything  			), -- closes all open notifications and menus
    awful.key({ "Mod1"            }, "F1",        terminals_menu  				), -- opens terminal windows client menu
    awful.key({ "Mod1"            }, "F2",        tabs_menu  					), -- opens firefox tabs menu
    awful.key({ "Mod1"            }, "F5",        tags_per_layout				), -- shows a menu of the layouts used
    awful.key({ modkey			  }, "v",         paste_senza_formattazione  	), -- paste pure text without any formatting
    awful.key({ "Mod1"            }, "Escape",    function ()					   -- grab keyboard focus back from Adobe FLASH
														local c = client.focus
														if c.class == "Firefox" then
															local g = c:geometry()
															local b = c.border_width
															local mouse_pos = mouse.coords() 
															mouse.coords({x=g.x+b,y=g.y+b}) 
															root.fake_input("button_press", 1)
															root.fake_input("button_release", 1)
															mouse.coords(mouse_pos)
														end
												  end),
    awful.key({ "Mod1"            }, "F3",        function () cmenu = clients_menu()  	end), -- open clients menu
	-- }}}

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
				  -- usefuleval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "o",      function ()  awful.client.movetoscreen() 			  ; mouse.coords({x=center('x'),y=center('y')}) end),
    awful.key({ modkey, "Shift"   }, "o",      function (c) awful.client.movetoscreen(c, c.screen -1) ; mouse.coords({x=center('x'),y=center('y')}) end)
--    awful.key({ modkey,           }, "n",
--        function (c)
--            -- The client currently has the input focus, so it cannot be
--            -- minimized, since minimized clients can't have the focus.
--            c.minimized = true
--        end),
--    awful.key({ modkey,           }, "m",
--        function (c)
--            c.maximized_horizontal = not c.maximized_horizontal
--            c.maximized_vertical   = not c.maximized_vertical
--        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ }, 2, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
					 -- {{{ Massi: no maximized windows to avoid having them floating
					 maximized_vertical   = false, 
					 maximized_horizontal = false,
					 -- }}}
                     buttons = clientbuttons } },
	-- {{{ Massi: regole per applicazioni specifiche
    { rule = { class = "MPlayer" }, 		properties = { floating = true } },
    { rule = { name  = "Download" },	   	properties = { floating = true } },
    { rule = { class = "Galculator" },   	properties = { floating = true } },
    { rule = { class = "Skype" },   		properties = { floating = true } },
    { rule = { class = "Xsane" },   		properties = { floating = true } },
    { rule = { name  = "^xsane.*" },   		properties = { ontop    = true } },
    { rule = { class = "Audacious" },   	properties = { floating = true, border_width = 0, ontop = true } },
    { rule = { name  = ".*Skype.*Beta.*"},  properties = { floating = true, tag = (function() if screen.count()>1 then return tags[2][9] else return tags[1][9] end end)(), ontop = true } , callback = function (c) position_inside_screen(c,10,50) end},
    { rule = { name  = "Buddy List" },   	properties = { floating = true, tag = (function() if screen.count()>1 then return tags[2][9] else return tags[1][9] end end)(), ontop = true } , callback = function (c) c:geometry({ width=200, height=300}) ; position_inside_screen(c,-10,50) end},
    { rule = { role  = "gimp-toolbox" }, 	properties = { floating = true, geometry = { width = 204} } }, --instructions to have titlebar: open gimp, Edit -> preferences -> window management -> Window manager hints : Normal window
	-- generic rules that need to be applied after rules defined for specific windows (eg. Pidgin "buddy list")
    { rule = { class = "Pidgin" },   		properties = { floating = true } },
    { rule = { class = "Gimp" },    		properties = { floating = true } },
    { rule = { class = "Plugin-container"}, properties = { floating = true, fullscreen = true } , callback = inhibit_screensaver },
	-- }}}

}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
--    -- Enable sloppy focus
--    c:connect_signal("mouse::enter", function(c)
--        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--            and awful.client.focus.filter(c) then
--            client.focus = c
--        end
--    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    if (c.type == "normal" or c.type == "dialog") and awful.client.floating.get(c) 
		and (c.class ~= "MPlayer" and c.class ~= "Audacious" and c.class ~= "Plugin-container") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        -- right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- startup list

run_once("xscreensaver","-no-splash")
if hostname ~= "salotto" then
	run_once("numlockx")
end
if hostname == "salotto" then
	run_once("setxkbmap -option caps:none")
end
