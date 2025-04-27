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

return helpers
