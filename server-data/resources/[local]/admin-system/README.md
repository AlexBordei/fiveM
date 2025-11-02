# Admin System

In-game admin system with commands and permissions for Legacy Romania FiveM server.

## Features

- **Permission Levels**: Moderator, Admin, Super Admin
- **Player Management**: Kick, freeze, teleport, heal
- **Vehicle Management**: Spawn, delete, fix vehicles
- **Server Control**: Weather, time, announcements
- **Admin Powers**: God mode, noclip
- **Simple Setup**: Identifier-based authentication

## Installation

1. Resource is already in `server-data/resources/[local]/admin-system/`

2. **Add your identifier to config.lua:**
   ```lua
   Config.Admins = {
       'steam:110000XXXXXXXX',  -- Your Steam ID
   }
   ```

3. **Add to server.cfg:**
   ```
   ensure admin-system
   ```

4. **Restart server or start resource:**
   ```
   restart admin-system
   ```

## Finding Your Identifier

Your identifier will show in the server console when you connect:

```
[playerConnecting] Player connecting: YourName
  steam:110000XXXXXXXX
  license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Copy the `steam:` or `license:` identifier and add it to `config.lua`.

## Permission Levels

**Moderator (Level 1):**
- Kick players
- Teleport (goto, bring)
- Freeze players
- Heal/armor players
- Spawn/delete/fix vehicles

**Admin (Level 2):**
- All moderator commands
- Ban/unban players
- Server announcements
- Weather/time control
- God mode
- Noclip

**Super Admin (Level 3):**
- All admin commands
- Full server control

## Commands

### Player Management

| Command | Permission | Usage | Description |
|---------|-----------|-------|-------------|
| `/kick` | Moderator | `/kick [id] [reason]` | Kick a player |
| `/bring` | Moderator | `/bring [id]` | Bring player to you |
| `/goto` | Moderator | `/goto [id]` | Teleport to player |
| `/freeze` | Moderator | `/freeze [id]` | Freeze/unfreeze player |
| `/heal` | Moderator | `/heal [id]` | Heal player (no id = self) |
| `/armor` | Moderator | `/armor [id]` | Give armor (no id = self) |
| `/players` | Moderator | `/players` | List online players |

### Teleportation

| Command | Permission | Usage | Description |
|---------|-----------|-------|-------------|
| `/tp` | Moderator | `/tp [x] [y] [z]` | Teleport to coordinates |
| `/goto` | Moderator | `/goto [id]` | Teleport to player |
| `/bring` | Moderator | `/bring [id]` | Bring player to you |

### Vehicle Management

| Command | Permission | Usage | Description |
|---------|-----------|-------|-------------|
| `/car` | Moderator | `/car [model]` | Spawn vehicle |
| `/dv` | Moderator | `/dv` | Delete current/nearby vehicle |
| `/fix` | Moderator | `/fix` | Fix current vehicle |

**Popular vehicle models:**
- Sports: `adder`, `t20`, `zentorno`, `elegy2`
- SUVs: `insurgent`, `granger`, `baller`
- Sedans: `sultan`, `kuruma`, `schafter2`
- Emergency: `police`, `ambulance`, `firetruk`

### Server Control

| Command | Permission | Usage | Description |
|---------|-----------|-------|-------------|
| `/weather` | Admin | `/weather [type]` | Change weather |
| `/time` | Admin | `/time [hour] [min]` | Set time |
| `/announce` | Admin | `/announce [msg]` | Server announcement |

**Weather types:**
`CLEAR`, `EXTRASUNNY`, `CLOUDS`, `OVERCAST`, `RAIN`, `THUNDER`, `SNOW`, `BLIZZARD`

**Time examples:**
- `/time 12 0` - Noon
- `/time 0 0` - Midnight
- `/time 18 30` - 6:30 PM

### Admin Powers

| Command | Permission | Usage | Description |
|---------|-----------|-------|-------------|
| `/god` | Admin | `/god` | Toggle god mode (invincibility) |
| `/noclip` | Admin | `/noclip` | Toggle noclip (fly through walls) |

**Noclip controls:**
- `W/S` - Forward/Backward
- `A/D` - Turn left/right
- `Q/E` - Down/Up
- `Shift` - Fast speed
- `Ctrl` - Slow speed

### Menu

| Command | Permission | Usage | Description |
|---------|-----------|-------|-------------|
| `/admin` | Any Admin | `/admin` | Show admin menu with all commands |

## Configuration

### Adding Admins

Edit `config.lua`:

```lua
Config.Admins = {
    'steam:110000XXXXXXXX',
    'license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
}
```

### Setting Permission Levels

```lua
Config.AdminLevels = {
    ['steam:110000XXXXXXXX'] = Config.Permissions.superadmin,
    ['steam:110000YYYYYYYY'] = Config.Permissions.moderator,
}
```

If not specified, admins default to Moderator level.

### Customizing Permissions

Edit command permissions in `config.lua`:

```lua
Config.CommandPermissions = {
    kick = Config.Permissions.moderator,
    ban = Config.Permissions.admin,
    -- etc...
}
```

## Examples

**Kick a player:**
```
/kick 1 Trolling
```

**Teleport to player:**
```
/goto 5
```

**Spawn a car:**
```
/car adder
```

**Set weather to rain:**
```
/weather RAIN
```

**Set time to sunset:**
```
/time 19 30
```

**Heal yourself:**
```
/heal
```

**Announce to server:**
```
/announce Server restart in 10 minutes!
```

## Troubleshooting

**Commands not working:**
- Check your identifier is in `Config.Admins`
- Check resource is running: `ensure admin-system` in console
- Check console for errors

**"You do not have permission":**
- Verify your identifier is correct
- Check your permission level in `Config.AdminLevels`

**Player IDs not working:**
- Use `/players` to see correct IDs
- IDs change when players disconnect/reconnect

**Noclip not working:**
- Make sure you have Admin or Super Admin level
- Try `/god` first if you're taking damage

## Security Notes

- Only give admin to trusted players
- Never share the server.cfg file (contains license key)
- Keep Config.Admins list private
- Regularly check console for admin activity
- Consider using higher permission levels for destructive commands

## Updates

To update admin list without restarting server:

1. Edit `config.lua`
2. In server console: `restart admin-system`
3. New admins can now use commands

## Version

**Version:** 1.0.0
**Last Updated:** November 2, 2025
**Compatibility:** FiveM (all builds)
