local awful = require('awful')
local constants = require('core.constants')
local gears = require('gears')

local mouse = constants.mouse
local keys = constants.keys

local mousebindings = {}

mousebindings.client = gears.table.join(
  awful.button({}, mouse.left_click, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
  end),
  awful.button({ keys.modkey }, mouse.left_click, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ keys.modkey }, mouse.right_click, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.resize(c)
  end)
)

mousebindings.global = gears.table.join(
  awful.button({}, mouse.scroll_up, awful.tag.viewnext),
  awful.button({}, mouse.scroll_down, awful.tag.viewprev)
)

return mousebindings
