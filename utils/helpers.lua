local gears = require('gears')

local helpers = {}

helpers.resize_font = function(font, new_size)
  local split_font = {}
  for word in string.gmatch(font, '%S+') do
    table.insert(split_font, word)
  end

  split_font[#split_font + 1] = new_size

  return table.concat(split_font, ' ')
end

helpers.span_tag_wrapper = function(text)
  return '<span weight="bold">' .. text .. '</span>'
end

helpers.get_font_size = function(font)
  local split_font = {}
  for word in string.gmatch(font, '%S+') do
    table.insert(split_font, word)
  end

  return tonumber(split_font[#split_font])
end

return helpers
