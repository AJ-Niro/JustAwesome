local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup')

local hotkeys_popup_widget = hotkeys_popup.widget.new({
  width = 800,
  height = 600,
  group_margin = beautiful.hotkeys_group_margin,
  label_margin = beautiful.hotkeys_label_margin,
  font = beautiful.hotkeys_font,
  description_font = beautiful.hotkeys_description_font,
  bg = beautiful.hotkeys_bg,
  fg = beautiful.hotkeys_fg,
  border_color = beautiful.hotkeys_border_color,
  modifiers_fg = beautiful.hotkeys_modifiers_fg,
  label_bg = beautiful.hotkeys_label_bg,
  label_fg = beautiful.hotkeys_label_fg,
  border_width = beautiful.hotkeys_border_width,
  shape = beautiful.hotkeys_shape,
})

return hotkeys_popup_widget
