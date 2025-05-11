local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local helpers = require('utils.helpers')
local wibox = require('wibox')

local font_size = helpers.get_font_size(beautiful.font)

local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local volume = {}

volume.icons = {
  low = '\u{f026}',
  medium = '\u{f027}',
  high = '\u{f028}',
  mute = '\u{eee8}',
}

volume.icons_width = {
  low = dpi(font_size - 2),
  medium = dpi(font_size),
  high = dpi(font_size + 6),
  mute = dpi(font_size + 4),
}

volume.widget = wibox.widget({
  {
    id = 'icon',
    widget = wibox.widget.textbox,
    font = beautiful.font,
    markup = helpers.span_tag_wrapper(volume.icons.low),
    forced_width = volume.icons_width.low,
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

volume.generate_overwriting = function(props)
  if props == nil then props = {} end

  if props.spacing ~= nil then volume.widget.spacing = props.spacing end

  return volume.widget
end

volume.update = function()
  awful.spawn.easy_async_with_shell('echo "$(pamixer --get-volume)-$(pamixer --get-mute)"', function(stdout)
    local text_widget = volume.widget:get_children_by_id('text')[1]
    local icon_widget = volume.widget:get_children_by_id('icon')[1]

    local volume_str, mute_status = stdout:match('^(%d+)-(%a+)')
    local volume_num = tonumber(volume_str)

    if mute_status == 'true' then
      icon_widget.markup = helpers.span_tag_wrapper(volume.icons.mute)
      icon_widget.forced_width = volume.icons_width.mute
      text_widget.markup = helpers.span_tag_wrapper('Mute')
      return
    end

    text_widget.markup = helpers.span_tag_wrapper(volume_num .. '%')

    if volume_num == 0 then
      icon_widget.markup = helpers.span_tag_wrapper(volume.icons.mute)
      icon_widget.forced_width = volume.icons_width.mute
    elseif volume_num <= 33 then
      icon_widget.markup = helpers.span_tag_wrapper(volume.icons.low)
      icon_widget.forced_width = volume.icons_width.low
    elseif volume_num <= 66 then
      icon_widget.markup = helpers.span_tag_wrapper(volume.icons.medium)
      icon_widget.forced_width = volume.icons_width.medium
    else
      icon_widget.markup = helpers.span_tag_wrapper(volume.icons.high)
      icon_widget.forced_width = volume.icons_width.high
    end

    gears.debug.dump(icon_widget.markup, 'mute_status')
  end)
end

volume.increase = function()
  awful.spawn('pamixer --increase 5')
  volume.update()
end

volume.decrease = function()
  awful.spawn('pamixer --decrease 5')
  volume.update()
end

volume.toggle_mute = function()
  awful.spawn.easy_async_with_shell('pamixer --get-mute', function(stdout)
    local mute_state = stdout:gsub('%s+', '')
    if mute_state == 'true' then
      awful.spawn('pamixer --unmute')
    else
      awful.spawn('pamixer --mute')
    end
    volume.update()
  end)
end

volume.keybindings = gears.table.join(
  awful.key({}, 'XF86AudioRaiseVolume', function()
    volume.increase()
  end, { description = 'Increase volume', group = 'media' }),

  awful.key({}, 'XF86AudioLowerVolume', function()
    volume.decrease()
  end, { description = 'Decrease volume', group = 'media' }),

  awful.key({}, 'XF86AudioMute', function()
    volume.toggle_mute()
  end, { description = 'Mute volume', group = 'media' })
)

-- Update the widget before use it
volume.update()

return volume
