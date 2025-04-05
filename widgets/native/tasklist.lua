local awful = require('awful')
local constants = require('core.constants')
local gears = require('gears')

local mouse = constants.mouse

local tasklist_widget = {}

tasklist_widget.buttons = gears.table.join(
  awful.button({}, mouse.left_click, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal('request::activate', 'tasklist', { raise = true })
    end
  end),
  awful.button({}, mouse.right_click, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, mouse.scroll_up, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, mouse.scroll_down, function()
    awful.client.focus.byidx(-1)
  end)
)

tasklist_widget.generate = function(s)
  return awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_widget.buttons,
  })
end

return tasklist_widget
