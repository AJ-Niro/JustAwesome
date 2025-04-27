local awful = require('awful')
local gears = require('gears')

local media_player = {}

media_player.keybindings = gears.table.join(
  awful.key({}, 'XF86AudioPlay', function()
    awful.spawn.with_shell('playerctl play-pause')
  end, { description = 'Toggle Play - Pause', group = 'media' }),
  awful.key({}, 'XF86AudioNext', function()
    awful.spawn.with_shell('playerctl next')
  end, { description = 'Play Next', group = 'media' }),
  awful.key({}, 'XF86AudioPrev', function()
    awful.spawn.with_shell('playerctl previous')
  end, { description = 'Play Previous', group = 'media' })
)

return media_player
