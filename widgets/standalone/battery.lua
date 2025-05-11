local awful = require('awful')
local beautiful = require('beautiful')
local helpers = require('utils.helpers')
local wibox = require('wibox')

local battery = {}

-- {{{
-- CONSTANST
battery.timeoutSegs = 5

battery.command = 'acpi -b'

battery.icons = {
  ['0'] = '\u{f008e}',
  ['10'] = '\u{f007a}',
  ['20'] = '\u{f007b}',
  ['30'] = '\u{f007c}',
  ['40'] = '\u{f007d}',
  ['50'] = '\u{f007e}',
  ['60'] = '\u{f007f}',
  ['70'] = '\u{f0080}',
  ['80'] = '\u{f0081}',
  ['90'] = '\u{f0082}',
  ['100'] = '\u{f0079}',
  bolt = '\u{f140b}',
}

-- }}}

battery.widget = wibox.widget({
  {
    id = 'icon',
    widget = wibox.widget.textbox,
    font = beautiful.font,
    markup = helpers.span_tag_wrapper(battery.icons['0']),
  },
  {
    id = 'text',
    widget = wibox.widget.textbox,
    font = beautiful.font,
    markup = helpers.span_tag_wrapper('0%'),
  },
  spacing = 3,
  valign = 'center',
  halign = 'center',
  layout = wibox.layout.fixed.horizontal,
})

battery.generate_overwriting = function(props)
  if props == nil then props = {} end

  if props.spacing ~= nil then battery.widget.spacing = props.spacing end

  return battery.widget
end

battery.get_battery_icon = function(battery_percentage)
  local battery_percentage_number = tonumber(battery_percentage)
  local percentage_tens = math.floor(battery_percentage_number / 10) * 10
  local battery_icon = battery.icons[tostring(percentage_tens)]
  return battery_icon
end

battery.update_widget = function(stdout)
  local text_widget = battery.widget:get_children_by_id('text')[1]
  local icon_widget = battery.widget:get_children_by_id('icon')[1]
  local battery_percentage = stdout:match('(%d?%d?%d)%%')
  local charging_status = stdout:match('Discharging') and 'discharging' or 'charging'

  local bolt_icon = ''
  if charging_status == 'charging' then bolt_icon = battery.icons.bolt end

  if battery_percentage then
    local battery_icon = battery.get_battery_icon(battery_percentage)
    icon_widget.markup = helpers.span_tag_wrapper(battery_icon .. bolt_icon)
    text_widget.markup = helpers.span_tag_wrapper(battery_percentage .. '%')
  else
    text_widget.markup = helpers.span_tag_wrapper('N/A')
  end
end

awful.widget.watch(battery.command, battery.timeoutSegs, function(widget, stdout)
  battery.update_widget(stdout)
end)

return battery
