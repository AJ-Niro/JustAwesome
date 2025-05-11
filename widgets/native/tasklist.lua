local awful = require('awful')
local constants = require('core.constants')
local gears = require('gears')
local wibox = require('wibox')

local mouse = constants.mouse

local tasklist_widget = {}

tasklist_widget.fallback_icon = gears.filesystem.get_configuration_dir() .. 'assets/default_client_icon.png'

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

tasklist_widget.generate = function(s, props)
  if props == nil then props = {} end
  if props.spacing == nil then props.spacing = 5 end
  if props.focus_bar_height == nil then props.focus_bar_height = 3 end
  return awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    source = function()
      -- Reverse the list of clients
      local clients = awful.widget.tasklist.source.all_clients()
      local reversed_clients = {}
      for i = #clients, 1, -1 do
        table.insert(reversed_clients, clients[i])
      end
      return reversed_clients
    end,
    buttons = tasklist_widget.buttons,
    layout = {
      spacing = props.spacing,
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          id = 'icon_role',
          widget = wibox.widget.imagebox,
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
      },
      {
        wibox.widget.base.make_widget(),
        forced_height = props.focus_bar_height,
        id = 'background_role',
        widget = wibox.container.background,
      },
      homogeneous = false,
      expand = true,
      layout = wibox.layout.grid,
      update_callback = function(self, c)
        if not c.icon then self:get_children_by_id('icon_role')[1].image = tasklist_widget.fallback_icon end
      end,
    },
  })
end

return tasklist_widget
