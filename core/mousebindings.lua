local awful = require('awful')
local gears = require('gears')
local keybindings = require('core.keybindings')

local mousebindings = {}

local keys = {
  left_click = 1,
  middle_click = 2,
  right_click = 3,
  scroll_up = 4,
  scroll_down = 5,
}

mousebindings.keys = keys

mousebindings.client = gears.table.join(
  awful.button({}, keys.left_click, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
  end),
  awful.button({ keybindings.modkey }, keys.left_click, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ keybindings.modkey }, keys.right_click, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.resize(c)
  end)
)

mousebindings.global = gears.table.join(
  awful.button({}, keys.scroll_up, awful.tag.viewnext),
  awful.button({}, keys.scroll_down, awful.tag.viewprev)
)

return mousebindings
