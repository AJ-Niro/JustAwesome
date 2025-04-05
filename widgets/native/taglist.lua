local awful = require('awful')
local constants = require('core.constants')
local gears = require('gears')

local mouse = constants.mouse
local keys = constants.keys

local taglist = {}

taglist.buttons = gears.table.join(
  awful.button({}, mouse.left_click, function(t)
    t:view_only()
  end),
  awful.button({ keys.modkey }, mouse.left_click, function(t)
    if client.focus then client.focus:move_to_tag(t) end
  end),
  awful.button({}, mouse.right_click, awful.tag.viewtoggle),
  awful.button({ keys.modkey }, mouse.right_click, function(t)
    if client.focus then client.focus:toggle_tag(t) end
  end),
  awful.button({}, mouse.scroll_up, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, mouse.scroll_down, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

taglist.generate = function(s)
  return awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist.buttons,
  })
end

return taglist
