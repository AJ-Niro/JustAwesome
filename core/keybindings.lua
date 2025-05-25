local awful = require('awful')
local constants = require('core.constants')
local gears = require('gears')
local hotkeys_popup = require('widgets.native.hotkeys_popup')

local current_path = gears.filesystem.get_configuration_dir()
local keys = constants.keys

local keybindings = {}

keybindings.global = gears.table.join(
  awful.key({ keys.modkey }, 'Escape', awful.tag.history.restore, { description = 'go back', group = 'tag' }),

  -- Layout manipulation
  awful.key(
    { keys.modkey },
    'u',
    awful.client.urgent.jumpto,
    { description = 'jump to urgent client', group = 'client' }
  ),

  awful.key({ keys.modkey }, 'Tab', function()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
  end, { description = 'go back', group = 'client' }),

  awful.key({ keys.modkey }, 'Return', function()
    awful.spawn(terminal)
  end, { description = 'open a terminal', group = 'launcher' }),

  awful.key({ keys.modkey, 'Control' }, 'r', awesome.restart, { description = 'reload awesome', group = 'awesome' }),
  awful.key({ keys.modkey, 'Shift' }, 'q', awesome.quit, { description = 'quit awesome', group = 'awesome' }),

  awful.key({ keys.modkey }, 'space', function()
    awful.layout.inc(1)
  end, { description = 'select next', group = 'layout' }),
  awful.key({ keys.modkey, 'Shift' }, 'space', function()
    awful.layout.inc(-1)
  end, { description = 'select previous', group = 'layout' }),

  awful.key({ keys.modkey, 'Control' }, 'n', function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then c:emit_signal('request::activate', 'key.unminimize', { raise = true }) end
  end, { description = 'restore minimized', group = 'client' }),

  -- Prompt
  awful.key({ keys.modkey }, 'r', function()
    awful.screen.focused().mypromptbox:run()
  end, { description = 'run prompt', group = 'launcher' }),

  awful.key({ keys.modkey }, 'x', function()
    awful.prompt.run({
      prompt = 'Run Lua code: ',
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. '/history_eval',
    })
  end, { description = 'lua execute prompt', group = 'awesome' }),

  awful.key({ keys.modkey }, 'p', function()
    awful.spawn.with_shell('rofi -show drun -config ' .. current_path .. 'apps/rofi.rasi')
  end, { description = 'launch rofi', group = 'launcher' })
)

keybindings.client = gears.table.join(
  awful.key({ keys.modkey, keys.alt }, 'f', function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = 'toggle fullscreen', group = 'client' }),
  awful.key({ keys.modkey, 'Shift' }, 'c', function(c)
    c:kill()
  end, { description = 'close', group = 'client' }),
  awful.key(
    { keys.modkey, 'Control' },
    'space',
    awful.client.floating.toggle,
    { description = 'toggle floating', group = 'client' }
  ),
  awful.key({ keys.modkey, 'Control' }, 'Return', function(c)
    c:swap(awful.client.getmaster())
  end, { description = 'move to master', group = 'client' }),
  awful.key({ keys.modkey }, 'o', function(c)
    c:move_to_screen()
  end, { description = 'move to screen', group = 'client' }),
  awful.key({ keys.modkey }, 't', function(c)
    c.ontop = not c.ontop
  end, { description = 'toggle keep on top', group = 'client' }),
  awful.key({ keys.modkey }, 'n', function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, { description = 'minimize', group = 'client' }),
  awful.key({ keys.modkey }, 'm', function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = '(un)maximize', group = 'client' }),
  awful.key({ keys.modkey, 'Control' }, 'm', function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, { description = '(un)maximize vertically', group = 'client' }),
  awful.key({ keys.modkey, 'Shift' }, 'm', function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, { description = '(un)maximize horizontally', group = 'client' }),
  awful.key({ keys.modkey }, '\\', function()
    hotkeys_popup:show_help()
  end, { description = 'Show popup help', group = 'awesome' })
)

keybindings.generate_taglist_keys = function(tag_keys_table)
  for i, key in ipairs(tag_keys_table) do
    keybindings.global = gears.table.join(
      keybindings.global,

      awful.key({ keys.modkey }, key, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then tag:view_only() end
      end, { description = 'view tag #' .. key, group = 'tag' }),

      awful.key({ keys.modkey, 'Shift' }, key, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:move_to_tag(tag) end
        end
      end, { description = 'move focused client to tag #' .. key, group = 'tag' })
    )
  end
end

keybindings.extra = gears.table.join(awful.key({}, 'Print', function()
  awful.spawn.with_shell('flameshot gui')
end, { description = 'Take a screenshot', group = 'media' }))

return keybindings
