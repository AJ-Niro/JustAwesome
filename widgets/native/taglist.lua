local awful = require('awful')
local beautiful = require('beautiful')
local constants = require('core.constants')
local gears = require('gears')
local wibox = require('wibox')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local mouse = constants.mouse
local keys = constants.keys

local taglist = {}

taglist.buttons = gears.table.join(
  awful.button({}, mouse.left_click, function(t)
    t:view_only()
  end),
  awful.button({ keys.modkey }, mouse.left_click, function(t)
    if client.focus then client.focus:move_to_tag(t) end
  end),
  awful.button({}, mouse.right_click, awful.tag.viewtoggle),
  awful.button({ keys.modkey }, mouse.right_click, function(t)
    if client.focus then client.focus:toggle_tag(t) end
  end),
  awful.button({}, mouse.scroll_up, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, mouse.scroll_down, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

taglist.create_single_tag = function(s, tag_index, props)
  props.fake_transparent = beautiful.bg_normal
  return awful.widget.taglist({
    screen = s,
    filter = function(t)
      return t.index == tag_index
    end,
    buttons = taglist.buttons,
    style = {
      shape = gears.shape.rounded_rect,
    },
    widget_template = {
      {
        {
          widget = wibox.widget.textbox,
          markup = '',
        },
        id = 'dot_widget',
        widget = wibox.container.background,
        bg = props.fake_transparent,
        shape = gears.shape.circle,
        shape_border_width = props.tag_tiny_dot_size,
        shape_border_color = props.fake_transparent, -- Fake transparent color
      },
      id = 'ring_widget',
      widget = wibox.container.background,
      bg = beautiful.color_transparent,
      shape = gears.shape.circle,
      shape_clip = true,
      shape_border_width = props.tag_ring_width,
      shape_border_color = beautiful.fg_normal,
      forced_height = props.height,
      forced_width = props.height,
      create_callback = function(self, tag)
        local dot_widget = self:get_children_by_id('dot_widget')[1]

        local is_tag_selected = tag.selected
        if is_tag_selected then
          dot_widget.bg = beautiful.fg_normal
          dot_widget.shape_border_width = props.tag_big_dot_size
          return
        end

        local does_tag_have_client = #tag:clients() > 0
        if does_tag_have_client then dot_widget.bg = beautiful.fg_normal end
      end,
      update_callback = function(self, tag)
        local dot_widget = self:get_children_by_id('dot_widget')[1]
        local ring_widget = self:get_children_by_id('ring_widget')[1]
        ring_widget.shape_border_color = beautiful.fg_normal

        local is_tag_selected = tag.selected
        if is_tag_selected then
          dot_widget.bg = beautiful.fg_normal
          dot_widget.shape_border_width = props.tag_big_dot_size
          return
        end

        local is_tag_urgent = tag.urgent
        if is_tag_urgent then
          ring_widget.shape_border_color = beautiful.bg_urgent
          dot_widget.bg = beautiful.bg_urgent
          dot_widget.shape_border_width = props.tag_big_dot_size
          return
        end

        local does_tag_have_client = #tag:clients() > 0
        if does_tag_have_client then
          dot_widget.bg = beautiful.fg_normal
          dot_widget.shape_border_width = props.tag_tiny_dot_size
          return
        end

        dot_widget.bg = props.fake_transparent
      end,
    },
  })
end

taglist.generate_middle_icon = function(s, props)
  local split_font = {}
  for word in string.gmatch(beautiful.font, '%S+') do
    table.insert(split_font, word)
  end

  split_font[#split_font + 1] = props.height

  local resized_font = table.concat(split_font, ' ')

  return wibox.widget({
    widget = wibox.widget.textbox,
    text = props.middle_icon,
    font = resized_font,
    forced_width = dpi(props.height),
  })
end

taglist.generate = function(s, props)
  if props == nil then props = {} end
  if props.tag_count == nil then props.tag_count = 8 end
  if props.tag_spacing == nil then props.tag_spacing = 1 end
  if props.tag_ring_width == nil then props.tag_ring_width = dpi(4) end
  if props.tag_big_dot_size == nil then props.tag_big_dot_size = dpi(8) end
  if props.tag_tiny_dot_size == nil then props.tag_tiny_dot_size = dpi(11) end

  if props.height == nil then props.height = s.mywibox.height end
  if props.middle_icon == nil then
    props.middle_icon = '\u{f09fe}' -- Nerd Font Icon: nf-md-layers_outline
  end

  local tags_layout = wibox.layout.fixed.horizontal()
  tags_layout.fill_space = true
  tags_layout.spacing = props.tag_spacing

  local middle_icon_index = math.ceil(props.tag_count / 2) + 1
  for i = 1, props.tag_count do
    if i == middle_icon_index then -- Add Middle Icon
      tags_layout:add(taglist.generate_middle_icon(s, props))
    end

    local tag_widget = taglist.create_single_tag(s, i, props)
    tags_layout:add(tag_widget)
  end
  return tags_layout
end

return taglist
