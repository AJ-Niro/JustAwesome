local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local brightness = {}

-- State to prevent double pressing bug
brightness.state = {
  up_was_pressed = false,
  down_was_pressed = false,
}

brightness.widget = awful.popup({
  screen = awful.screen.focused(),
  widget = {
    max_value = 100,
    value = 57,
    color = beautiful.bg_focus,
    background_color = beautiful.bg_normal,
    bar_shape = gears.shape.rounded_bar,
    border_width = dpi(2),
    margins = dpi(8),
    border_color = beautiful.fg_normal,
    widget = wibox.widget.progressbar,
    shape = gears.shape.rounded_bar,
    id = 'progressbar',
  },
  shape = gears.shape.rounded_rect,
  maximum_height = dpi(40),
  maximum_width = dpi(150),
  ontop = true,
  visible = false,
  placement = function(c)
    awful.placement.top_right(c, { margins = { top = c.screen.mywibox.height + 15, right = 5 } })
  end,
})

brightness._timer = gears.timer({
  timeout = 1.5,
  autostart = false,
  callback = function()
    brightness.widget.visible = false
  end,
})

brightness.show_widget = function(quantity)
  local progressbar = brightness.widget.widget:get_children_by_id('progressbar')[1]

  local new_value = progressbar._private.value + quantity
  if new_value < 0 or new_value > 100 then return end

  progressbar:set_value(new_value)
  awful.spawn('brightnessctl set ' .. new_value .. '%')
  brightness.widget.visible = true
  brightness._timer:again()
end

brightness.keybindings = gears.table.join(
  awful.key({}, 'XF86MonBrightnessUp', function()
    if brightness.state.up_was_pressed == true then
      brightness.state.up_was_pressed = false
      return
    end
    brightness.state.up_was_pressed = true

    brightness.show_widget(5)
  end),
  awful.key({}, 'XF86MonBrightnessDown', function()
    if brightness.state.down_was_pressed == true then
      brightness.state.down_was_pressed = false
      return
    end
    brightness.state.down_was_pressed = true

    brightness.show_widget(-5)
  end)
)

brightness.update = function()
  awful.spawn.easy_async_with_shell(
    "brightnessctl | grep 'Current brightness:' | cut -f2 -d '(' | cut -f1 -d '%'",
    function(stdout)
      local progressbar = brightness.widget.widget:get_children_by_id('progressbar')[1]
      progressbar:set_value(tonumber(stdout))
    end
  )
end

-- Init widget before use it
brightness.update()

return brightness
