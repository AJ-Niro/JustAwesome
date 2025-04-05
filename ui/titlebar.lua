local constants = require('core.constants')
local wibox = require('wibox')

local awful = require('awful')
local gears = require('gears')

local mouse = constants.mouse

local titlebar = {}

titlebar.generate = function(c)
  local buttons = gears.table.join(
    awful.button({}, mouse.left_click, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, mouse.right_click, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = 'center',
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = titlebar.buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end

return titlebar
