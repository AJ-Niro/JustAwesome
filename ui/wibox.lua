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

  s.mykeyboardlayout = awful.widget.keyboardlayout()

  -- Create a textclock widget
  s.mytextclock = wibox.widget.textclock()

  -- Add widgets to the wibox
  s.mywibox:setup({
    {
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = 5,
        s.mylayoutbox,
        s.mytasklist,
        s.mypromptbox,
      },
      nil,
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = 5,
        s.mykeyboardlayout,
        wibox.widget.systray(),
        s.mytextclock,
      },
      layout = wibox.layout.align.horizontal,
    },
    {
      layout = wibox.container.place,
      s.mytaglist,
    },
    layout = wibox.layout.stack,
  })
end

return wibox_widget
