-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
-- }}}

-- {{{ Styles
theme.font_type = "sans"
if hostname == "salotto" then
	theme.fontsize     = 10
else
	theme.fontsize     = 8
end

theme.font = theme.font_type.." "..theme.fontsize

-- {{{ Colors
theme.fg_normal = "#DCDCCC"
theme.fg_focus  = "#BFCFFE"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#3F3F3F"
theme.bg_focus  = "#090909"
theme.bg_urgent = "#3F3F3F"
-- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#1d8dff"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#090909"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#0066B3"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/usr/share/awesome/themes/zenburn/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/zenburn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/usr/share/awesome/themes/zenburn/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
theme.tasklist_floating_icon = nil
-- }}}

-- {{{ Layout
theme.layout_tile       = "/usr/share/awesome/themes/zenburn/layouts/tile.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/zenburn/layouts/tileleft.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/zenburn/layouts/tilebottom.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/zenburn/layouts/tiletop.png"
theme.layout_fairv      = "/usr/share/awesome/themes/zenburn/layouts/fairv.png"
theme.layout_fairh      = "/usr/share/awesome/themes/zenburn/layouts/fairh.png"
theme.layout_spiral     = "/usr/share/awesome/themes/zenburn/layouts/spiral.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/zenburn/layouts/dwindle.png"
theme.layout_max        = "/usr/share/awesome/themes/zenburn/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/zenburn/layouts/fullscreen.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/zenburn/layouts/magnifier.png"
theme.layout_floating   = "/usr/share/awesome/themes/zenburn/layouts/floating.png"
-- }}}

-- {{{ Titlebar

theme.titlebar_close_button_focus               = conf_dir..'/theme/titlebar/close.gif'
theme.titlebar_close_button_normal              = theme.titlebar_close_button_focus

theme.titlebar_ontop_button_focus_active        = conf_dir..'/theme/titlebar/pin_a.gif'
theme.titlebar_ontop_button_normal_active       = theme.titlebar_ontop_button_focus_active
theme.titlebar_ontop_button_focus_inactive      = conf_dir..'/theme/titlebar/pin.gif'
theme.titlebar_ontop_button_normal_inactive     = theme.titlebar_ontop_button_focus_inactive

theme.titlebar_sticky_button_focus_active       = conf_dir..'/theme/titlebar/lock_a.gif'
theme.titlebar_sticky_button_normal_active      = theme.titlebar_sticky_button_focus_active
theme.titlebar_sticky_button_focus_inactive     = conf_dir..'/theme/titlebar/lock.gif'
theme.titlebar_sticky_button_normal_inactive    = theme.titlebar_sticky_button_focus_inactive

theme.titlebar_maximized_button_focus_active    = conf_dir..'/theme/titlebar/maximize_a.gif'
theme.titlebar_maximized_button_normal_active   = theme.titlebar_maximized_button_focus_active
theme.titlebar_maximized_button_focus_inactive  = conf_dir..'/theme/titlebar/maximize.gif'
theme.titlebar_maximized_button_normal_inactive = theme.titlebar_maximized_button_focus_inactive
-- }}}

return theme
