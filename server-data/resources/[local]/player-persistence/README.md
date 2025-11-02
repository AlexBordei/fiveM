# Player Persistence

Saves player settings and spawn location, allowing players to spawn at their last position when they reconnect.

## Features

- **Last Position Spawn** - Players spawn where they logged out
- **Auto-Save** - Position automatically saved every 30 seconds
- **Player Settings** - Remember player preferences
- **Character Creator Integration** - Works with character-creator for first-time players
- **Export Functions** - Easy integration with other resources

## Installation

1. **Already installed** in `server-data/resources/[local]/player-persistence/`

2. **Add to server.cfg**:
   ```cfg
   ensure player-persistence
   ```

3. **Load order** (important):
   ```cfg
   ensure spawnmanager
   ensure character-creator
   ensure player-persistence
   ```

## How It Works

### First Time Players
1. Player connects
2. No saved position found
3. Character creator is triggered (if available)
4. After character creation, position is saved

### Returning Players
1. Player connects
2. Last position is loaded from server
3. Player spawns at their last location
4. Position auto-saves every 30 seconds

## Configuration

### Change Auto-Save Interval

Edit [client.lua:5](client.lua#L5):
```lua
local saveInterval = 30000 -- Change to desired milliseconds
```

Examples:
- `15000` = 15 seconds
- `60000` = 1 minute
- `120000` = 2 minutes

## Commands

### /savepos
Manually save current position.

**Usage:**
```
/savepos
```

### /getpos
Display current position coordinates.

**Usage:**
```
/getpos
```

Example output:
```
Current position: x=-269.40, y=-955.30, z=31.20, heading=206.00
```

## Database Integration

### Current Storage
Currently stores data in memory (resets on server restart).

### Add Database Support

1. **Install MySQL resource** (oxmysql, mysql-async, or ghmattimysql)

2. **Create database table**:
```sql
CREATE TABLE IF NOT EXISTS player_data (
    identifier VARCHAR(50) PRIMARY KEY,
    data TEXT NOT NULL,
    last_saved TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

3. **Update server.lua**:

Replace the `SavePlayerData` function:
```lua
local function SavePlayerData(source, data)
    local identifier = GetPlayerIdentifier(source, 0)
    if not identifier then return end

    -- Using oxmysql
    exports.oxmysql:execute('INSERT INTO player_data (identifier, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?', {
        identifier,
        json.encode(data),
        json.encode(data)
    })
end
```

Replace the `LoadPlayerData` function:
```lua
local function LoadPlayerData(source)
    local identifier = GetPlayerIdentifier(source, 0)
    if not identifier then return nil end

    -- Using oxmysql
    local result = exports.oxmysql:executeSync('SELECT data FROM player_data WHERE identifier = ?', {
        identifier
    })

    if result[1] then
        return json.decode(result[1].data)
    end

    return nil
end
```

## Player Settings

### Available Settings

Edit [client.lua:154](client.lua#L154) to add custom settings:
```lua
local playerSettings = {
    volume = 1.0,
    hud = true,
    notifications = true,
    customSetting = false,
    -- Add your settings here
}
```

### Using Settings in Other Resources

```lua
-- Get all settings
local settings = exports['player-persistence']:GetSettings()

-- Set a specific setting
exports['player-persistence']:SetSetting('volume', 0.5)

-- Get a specific setting
local volume = exports['player-persistence']:GetSettings().volume
```

## Integration with Other Resources

### Save Custom Data

From another resource's server-side:
```lua
-- Get player data
local data = exports['player-persistence']:LoadPlayerData(source)

-- Modify data
data.customData = {
    money = 1000,
    job = 'police'
}

-- Save data
exports['player-persistence']:SavePlayerData(source, data)
```

### Trigger Position Save

From another resource's client-side:
```lua
-- Manually save position
exports['player-persistence']:SavePosition()
```

## Troubleshooting

**Player not spawning at last position:**
1. Check resource load order (player-persistence must load after spawnmanager)
2. Check F8 console for errors
3. Ensure player had previously saved a position

**Position resets on server restart:**
- This is expected with in-memory storage
- Implement database integration (see above)

**Player spawns twice:**
- Ensure auto-spawn is disabled in other resources
- Check for conflicting spawn scripts

**Settings not persisting:**
- Currently settings reset on server restart (use database)
- Check if SaveSettings() is being called

## Performance

- **CPU Usage:** Minimal (position saves are async)
- **Memory Usage:** < 1MB per player (in-memory)
- **Network Usage:** Very low (only saves on interval)
- **Database Queries:** 2 per player session (load on join, save on disconnect)

## Events

### Client Events

**player-persistence:receiveLastPosition**
```lua
-- Triggered when last position is received from server
AddEventHandler('player-persistence:receiveLastPosition', function(position)
    -- position = {x, y, z, heading}
end)
```

**player-persistence:receiveSettings**
```lua
-- Triggered when settings are received from server
AddEventHandler('player-persistence:receiveSettings', function(settings)
    -- settings = {volume, hud, notifications, ...}
end)
```

### Server Events

**player-persistence:savePosition**
```lua
-- Client requests to save position
-- Parameters: x, y, z, heading
```

**player-persistence:saveSettings**
```lua
-- Client requests to save settings
-- Parameters: settings (table)
```

**player-persistence:getLastPosition**
```lua
-- Client requests last position
```

**player-persistence:getSettings**
```lua
-- Client requests settings
```

## Exports

### Client-Side

```lua
-- Save current position
exports['player-persistence']:SavePosition()

-- Save settings
exports['player-persistence']:SaveSettings()

-- Get all settings
local settings = exports['player-persistence']:GetSettings()

-- Set a specific setting
exports['player-persistence']:SetSetting('settingName', value)
```

### Server-Side

```lua
-- Save player data
exports['player-persistence']:SavePlayerData(source, data)

-- Load player data
local data = exports['player-persistence']:LoadPlayerData(source)
```

## Notes

- Position is saved automatically every 30 seconds
- Position is also saved when the resource stops
- First-time players will use character-creator if available
- Compatible with all spawn systems that use spawnmanager
- Can store any custom data alongside position and settings

## Version

**Version:** 1.0.0
**Last Updated:** November 2, 2025
**Compatibility:** FiveM (all builds)
