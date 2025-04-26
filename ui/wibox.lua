local awful = require('awful')
local wibox = require('wibox')

-- JustAwesome native widgets
local layoutbox_wiget = require('widgets.native.layoutbox')
local taglist_widget = require('widgets.native.taglist')
local tasklist_widget = require('widgets.native.tasklist')

local wibox_widget = {}

wibox_widget.generate = function(s)
  -- Create the wibox
  s.mywibox = awful.wibar({ position = 'top', screen = s })

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = layoutbox_wiget.generate(s)

  -- Create a taglist widget
  s.mytaglist = taglist_widget.generate(s)

  -- Create a tasklist widget
  s.mytasklist = tasklist_widget.generate(s)

  -- Add widgets to the wibox
  s.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      wibox.widget.systray(),
      mytextclock,
      s.mylayoutbox,
    },
  })
end

return wibox_widget
