local awful = require('awful')
local constants = require('core.constants')
local gears = require('gears')

local mouse = constants.mouse

local layoutbox = {}

layoutbox.buttons = (
  gears.table.join(
    awful.button({}, mouse.left_click, function()
      awful.layout.inc(1)
    end),
    awful.button({}, mouse.right_click, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, mouse.scroll_up, function()
      awful.layout.inc(1)
    end),
    awful.button({}, mouse.scroll_down, function()
      awful.layout.inc(-1)
    end)
  )
)

layoutbox.generate = function(s)
  local box = awful.widget.layoutbox(s)
  box:buttons(layoutbox.buttons)
  return box
end

return layoutbox
