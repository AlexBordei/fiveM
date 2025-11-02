# txAdmin - FiveM Server Management Panel

**Documentation:** https://docs.fivem.net/docs/resources/txAdmin/

## Overview

txAdmin is a comprehensive web-based administration panel that comes pre-installed with FXServer (build 2524+). It provides server management, monitoring, and player administration through a modern web interface.

**No separate installation required** - included with FXServer.

## Key Features

### Server Management
- **Recipe-based deployment** - Set up server in under 60 seconds
- **Start/stop/restart** server instances
- **Resource management** - Start/stop/restart individual resources
- **Console access** - Live console with searchable logs
- **Configuration editor** - Edit server.cfg through web interface

### Player Administration
- **In-game admin menu** - Full-featured menu accessible in-game
- **Player database** - Track player history and actions
- **Ban system** - Temporary and permanent bans
- **Warning system** - Issue and track warnings
- **Whitelist management** - Discord-based or approval system
- **Player notes** - Add notes to player profiles

### Administrative Tools
- **NoClip mode** - Fly through the map
- **God mode** - Invincibility
- **SuperJump** - Enhanced jumping
- **Teleportation** - Teleport to waypoints or players
- **Vehicle spawning** - Spawn any vehicle
- **Player spectating** - Watch other players

### Monitoring & Performance
- **Auto-restart** - On crash or hang detection
- **Performance monitoring** - CPU/RAM usage tracking
- **Activity logging** - Connections, kills, chat, etc.
- **Performance charts** - Historical data with player counts
- **Live console** - Real-time server output
- **Action logging** - Track all admin actions

### Security
- **Brute-force protection** - Failed login prevention
- **Action logging** - Audit trail of all actions
- **Role-based permissions** - Master, Admin, Moderator roles
- **Self-contained database** - No MySQL required

## Installation & Setup

### Starting txAdmin

txAdmin starts automatically when you run FXServer without `+exec` arguments:

**Windows:**
```bash
FXServer.exe
```

**Linux:**
```bash
./run.sh
```

The panel will be accessible at the URLs shown in the console (typically http://localhost:40120).

### First-Time Setup

1. **Access Panel** - Open the URL shown in console
2. **Create Admin** - Set up master administrator account
3. **Deploy Server** - Choose a recipe or configure manually
4. **Configure** - Set server name, license key, etc.
5. **Start Server** - Launch your server

### Configuration ConVars

Add these to your server start command if needed:

```bash
# Server profile name
+set serverProfile "my-server"

# txAdmin HTTP port
+set txAdminPort 40120

# Binding interface
+set txAdminInterface "0.0.0.0"

# Enable verbose logging
+set txAdminVerbose true
```

## Web Panel Features

### Dashboard
- Server status and uptime
- Player count chart
- Performance metrics
- Recent actions
- Quick actions (start/stop/restart)

### Players
- Online players list
- Player search and filtering
- Player profiles with history
- Ban/warn/kick actions
- Session time tracking

### Server
- Server console with live output
- Resource list and management
- Server configuration editor
- Server controls (start/stop/restart)

### Admin Manager
- Admin accounts management
- Role assignment (Master/Admin/Moderator)
- Permission configuration
- Action logs

### Settings
- Server settings
- Discord integration
- Whitelist configuration
- Auto-restart settings
- Performance monitoring

### Diagnostics
- System information
- FXServer version
- Resource status
- Error logs

## In-Game Admin Menu

Access the menu by default with the configured hotkey (usually F1 or another key).

### Menu Options

**Player Management:**
- View online players
- Teleport to player
- Bring player to you
- Spectate player
- Freeze player
- Kick/Ban/Warn player

**Admin Tools:**
- NoClip mode
- God mode
- SuperJump
- Teleport to waypoint
- Teleport to coordinates
- Vehicle spawner
- Weapon menu

**Server Actions:**
- View server resources
- Restart resources
- Announcement system
- Clear player vehicles

## API & Events

### Server Events

#### txAdmin:events:serverShuttingDown

Triggered before server shutdown.

```lua
-- Server-side
AddEventHandler('txAdmin:events:serverShuttingDown', function()
    print('Server shutting down via txAdmin')

    -- Save player data
    for _, player in ipairs(GetPlayers()) do
        TriggerEvent('savePlayerData', player)
    end

    -- Clean up
    TriggerEvent('cleanupServer')
end)
```

#### txAdmin:events:scheduledRestart

Triggered before scheduled restart.

```lua
-- Server-side
AddEventHandler('txAdmin:events:scheduledRestart', function(secondsRemaining)
    print('Scheduled restart in ' .. secondsRemaining .. ' seconds')

    -- Notify players
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        args = {'Server', 'Restart in ' .. secondsRemaining .. ' seconds'}
    })
end)
```

#### txAdmin:events:playerDirectMessage

Player received DM from admin.

```lua
-- Client-side
RegisterNetEvent('txAdmin:events:playerDirectMessage')
AddEventHandler('txAdmin:events:playerDirectMessage', function(message)
    print('Admin message: ' .. message)

    -- Custom notification
    ShowNotification(message)
end)
```

#### txAdmin:events:announcement

Server-wide announcement.

```lua
-- Client-side
RegisterNetEvent('txAdmin:events:announcement')
AddEventHandler('txAdmin:events:announcement', function(message, author)
    print('Announcement from ' .. author .. ': ' .. message)

    -- Display custom notification
    TriggerEvent('chat:addMessage', {
        color = {255, 165, 0},
        args = {'[Announcement] ' .. author, message}
    })
end)
```

#### txAdmin:events:playerWarned

Player was warned by admin.

```lua
-- Client-side
RegisterNetEvent('txAdmin:events:playerWarned')
AddEventHandler('txAdmin:events:playerWarned', function(reason, author)
    print('You were warned by ' .. author .. ': ' .. reason)

    -- Show warning screen
    ShowWarningScreen(reason, author)
end)
```

#### txAdmin:events:playerKicked

Player was kicked (client-side, before kick).

```lua
-- Client-side
RegisterNetEvent('txAdmin:events:playerKicked')
AddEventHandler('txAdmin:events:playerKicked', function(reason, author)
    print('You were kicked by ' .. author .. ': ' .. reason)

    -- Show kick screen
    ShowKickScreen(reason, author)
end)
```

#### txAdmin:events:playerBanned

Player was banned (client-side, before ban).

```lua
-- Client-side
RegisterNetEvent('txAdmin:events:playerBanned')
AddEventHandler('txAdmin:events:playerBanned', function(reason, author, expiration)
    print('You were banned by ' .. author)
    print('Reason: ' .. reason)
    print('Expires: ' .. (expiration or 'Never'))
end)
```

### Checking Admin Permissions

```lua
-- Server-side
local function IsPlayerAdmin(player)
    return IsPlayerAceAllowed(player, 'txAdmin.access')
end

-- Check specific permission
local function HasPermission(player, permission)
    return IsPlayerAceAllowed(player, 'txAdmin.' .. permission)
end

-- Example usage
RegisterCommand('admintool', function(source)
    if IsPlayerAdmin(source) then
        -- Admin only action
        TriggerClientEvent('openAdminTool', source)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Error', 'You do not have permission'}
        })
    end
end)
```

## Common Use Cases

### Auto-Announce Restarts

```lua
-- Server-side
AddEventHandler('txAdmin:events:scheduledRestart', function(secondsRemaining)
    if secondsRemaining == 600 then -- 10 minutes
        TriggerClientEvent('chat:addMessage', -1, {
            color = {255, 165, 0},
            args = {'[Restart]', 'Server restarting in 10 minutes'}
        })
    elseif secondsRemaining == 300 then -- 5 minutes
        TriggerClientEvent('chat:addMessage', -1, {
            color = {255, 128, 0},
            args = {'[Restart]', 'Server restarting in 5 minutes'}
        })
    elseif secondsRemaining == 60 then -- 1 minute
        TriggerClientEvent('chat:addMessage', -1, {
            color = {255, 0, 0},
            args = {'[Restart]', 'Server restarting in 1 minute!'}
        })
    end
end)
```

### Save Data Before Shutdown

```lua
-- Server-side
AddEventHandler('txAdmin:events:serverShuttingDown', function()
    print('Saving all player data...')

    local players = GetPlayers()

    for _, player in ipairs(players) do
        -- Trigger save event
        TriggerEvent('savePlayerData', player)

        -- Notify player
        TriggerClientEvent('chat:addMessage', player, {
            color = {255, 255, 0},
            args = {'System', 'Your data has been saved'}
        })
    end

    print('All data saved!')
end)
```

### Custom Warning Screen

```lua
-- Client-side
local warningActive = false

RegisterNetEvent('txAdmin:events:playerWarned')
AddEventHandler('txAdmin:events:playerWarned', function(reason, author)
    warningActive = true

    -- Display warning
    CreateThread(function()
        local displayTime = 10000 -- 10 seconds
        local endTime = GetGameTimer() + displayTime

        while GetGameTimer() < endTime do
            Wait(0)

            -- Draw warning
            SetTextFont(4)
            SetTextScale(0.7, 0.7)
            SetTextColour(255, 0, 0, 255)
            SetTextOutline()
            SetTextCentre(true)

            BeginTextCommandDisplayText("STRING")
            AddTextComponentString("~r~WARNING")
            EndTextCommandDisplayText(0.5, 0.3)

            SetTextScale(0.4, 0.4)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentString("~w~You have been warned by: ~y~" .. author)
            EndTextCommandDisplayText(0.5, 0.4)

            BeginTextCommandDisplayText("STRING")
            AddTextComponentString("~w~Reason: ~o~" .. reason)
            EndTextCommandDisplayText(0.5, 0.45)
        end

        warningActive = false
    end)
end)
```

### Discord Integration

txAdmin has built-in Discord webhook support:

1. Go to Settings > Discord
2. Add webhook URLs for:
   - Status changes
   - Direct messages
   - Whitelist requests
3. Configure message format and colors

### Whitelist System

Enable in Settings > Whitelist:

**Discord-based:**
- Requires Discord role
- Automatic approval

**Approval-based:**
- Players request access
- Admins approve/deny

## Best Practices

1. **Use scheduled restarts** - Keep server fresh (daily recommended)
2. **Enable action logging** - Track all admin actions
3. **Set up Discord webhooks** - Monitor server remotely
4. **Regular backups** - Backup txData folder
5. **Use warnings** before bans - Give players chances
6. **Document bans** - Always provide clear reasons
7. **Limit master admins** - Only trusted individuals
8. **Review logs regularly** - Check for issues
9. **Update regularly** - FXServer updates include txAdmin
10. **Configure auto-restart** - Set crash detection thresholds

## Troubleshooting

**Can't access txAdmin:**
- Check if FXServer is running
- Verify port 40120 is not blocked
- Try http://localhost:40120
- Check firewall settings

**Admin menu not working:**
- Check menu keybind in settings
- Ensure player has admin permissions
- Restart the server
- Clear FiveM cache

**Scheduled restart not working:**
- Verify restart schedule in settings
- Check server time zone
- Review txAdmin logs

**Performance issues:**
- Reduce log retention
- Disable unnecessary monitoring
- Check system resources
- Update FXServer

## File Locations

**txData folder** (default locations):

- **Windows:** `%USERPROFILE%\AppData\Roaming\CitizenFX\txData`
- **Linux:** `~/.fxserver/txData`

Contains:
- Server profiles
- Admin accounts
- Player database
- Action logs
- Configuration

## Permissions System

### Permission Levels

1. **Master** - Full access, can create/delete admins
2. **Admin** - Most permissions, cannot manage admins
3. **Moderator** - Limited permissions, player management

### Custom Permissions

```cfg
# In server.cfg

# Grant txAdmin access
add_ace group.admin txAdmin.access allow

# Specific permissions
add_ace identifier.steam:110000XXXXXXXX txAdmin.access allow
add_ace identifier.steam:110000XXXXXXXX txAdmin.menu allow
```

## Related Resources

- **FXServer** - Core server software
- **Discord Bot** - Can integrate with txAdmin
- **Backup tools** - For txData folder

## Official Links

- **Documentation:** https://docs.fivem.net/docs/resources/txAdmin/
- **GitHub:** https://github.com/tabarra/txAdmin
- **Discord:** https://discord.gg/fivem
- **Forums:** https://forum.cfx.re/

## Notes

- txAdmin is actively developed and receives regular updates
- Some features may require latest FXServer version
- txAdmin data is stored separately from server data
- Multi-server management available (different profiles)
- Mobile-friendly web interface
