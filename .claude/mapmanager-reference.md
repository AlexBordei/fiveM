# FiveM Mapmanager Resource Reference

**Documentation:** https://docs.fivem.net/docs/resources/mapmanager/

## Overview

Mapmanager is a built-in CitizenFX resource that handles map changes, game types, and compatibility between gametypes and maps. It's essential for servers that want to switch between different maps and game modes dynamically.

**Repository:** Part of cfx-server-data

## Installation

Mapmanager is included in the default resources. Ensure it's started in your server.cfg:

```cfg
ensure mapmanager
```

## Exports

All exports are called using: `exports.mapmanager:exportName(args)`

### getCurrentGameType()

Returns the currently active game type.

```lua
local currentGameType = exports.mapmanager:getCurrentGameType()
print('Current game type: ' .. currentGameType)
```

### getCurrentMap()

Returns the currently loaded map.

```lua
local currentMap = exports.mapmanager:getCurrentMap()
if currentMap then
    print('Current map: ' .. currentMap)
else
    print('No map loaded')
end
```

### changeGameType(gameType)

Switches to a different game type.
- Automatically stops the current map if incompatible
- Stops the previous game type before starting the new one

```lua
-- Change to a different game type
exports.mapmanager:changeGameType('race')

-- Server-side example with command
RegisterCommand('setgametype', function(source, args)
    if args[1] then
        exports.mapmanager:changeGameType(args[1])
        TriggerClientEvent('chat:addMessage', -1, {
            args = {'Server', 'Game type changed to: ' .. args[1]}
        })
    end
end, true)
```

### changeMap(map)

Loads a different map.
- Stops the current map before starting the new one

```lua
-- Change to a different map
exports.mapmanager:changeMap('fivem-map-skater')

-- Server-side example with voting
local mapVotes = {}

RegisterCommand('votemap', function(source, args)
    if args[1] then
        mapVotes[args[1]] = (mapVotes[args[1]] or 0) + 1

        local maxVotes = 0
        local winningMap = nil

        for map, votes in pairs(mapVotes) do
            if votes > maxVotes then
                maxVotes = votes
                winningMap = map
            end
        end

        if maxVotes >= 3 then
            exports.mapmanager:changeMap(winningMap)
            mapVotes = {} -- Reset votes
        end
    end
end, false)
```

### doesMapSupportGameType(gameType, map)

Validates whether a specific map supports a given game type.

```lua
local supports = exports.mapmanager:doesMapSupportGameType('race', 'fivem-map-skater')

if supports then
    print('Map supports this game type')
    exports.mapmanager:changeMap('fivem-map-skater')
else
    print('Map does not support this game type')
end
```

### getMaps()

Returns a table containing all available maps.

```lua
local maps = exports.mapmanager:getMaps()

for _, map in ipairs(maps) do
    print('Available map: ' .. map)
end

-- Example: Random map rotation
CreateThread(function()
    while true do
        Wait(600000) -- Every 10 minutes

        local maps = exports.mapmanager:getMaps()
        local randomMap = maps[math.random(#maps)]

        exports.mapmanager:changeMap(randomMap)
    end
end)
```

### roundEnded()

Triggers round completion logic.
- Uses a 50-millisecond timeout before executing
- Useful for game modes with round-based gameplay

```lua
-- Call when round ends
exports.mapmanager:roundEnded()

-- Example: Timer-based rounds
local roundTime = 300 -- 5 minutes

CreateThread(function()
    while true do
        Wait(roundTime * 1000)
        exports.mapmanager:roundEnded()
    end
end)
```

## Creating Maps

### Map Structure

Maps are resources with a specific structure:

```
fivem-map-mymap/
├── fxmanifest.lua
└── map.lua
```

### fxmanifest.lua

```lua
fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'My Custom Map'
version '1.0.0'

-- Map file
map 'map.lua'
```

### map.lua

```lua
-- Define spawn points
local spawn = {
    { x = 0.0, y = 0.0, z = 72.0, heading = 0.0 },
    { x = 10.0, y = 10.0, z = 72.0, heading = 90.0 }
}

-- Register the map
exports['mapmanager']:addMap({
    gameTypes = { 'freeroam', 'race' },  -- Compatible game types
    spawnPoints = spawn
})

-- Or use simplified registration
-- This is handled by mapmanager automatically
```

### Simple Map Example

```lua
-- map.lua
exports['spawnmanager']:setAutoSpawnCallback(function()
    exports['spawnmanager']:spawnPlayer({
        x = 0.0,
        y = 0.0,
        z = 72.0,
        model = 'a_m_y_skater_01'
    })
end)

exports['spawnmanager']:forceRespawn()
```

## Creating Game Types

### Game Type Structure

```
my-gamemode/
├── fxmanifest.lua
└── gamemode.lua
```

### fxmanifest.lua

```lua
fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'My Custom Game Mode'
version '1.0.0'

client_scripts {
    'gamemode.lua'
}
```

### gamemode.lua

```lua
-- Listen for game type start
AddEventHandler('onClientGameTypeStart', function(gameType)
    if gameType == 'my-gamemode' then
        print('My game mode started!')

        -- Set game mode specific settings
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNow(PlayerId(), false)

        -- Disable auto-respawn
        exports.spawnmanager:setAutoSpawn(false)
    end
end)

-- Listen for game type stop
AddEventHandler('onClientGameTypeStop', function(gameType)
    if gameType == 'my-gamemode' then
        print('My game mode stopped!')

        -- Clean up
        exports.spawnmanager:setAutoSpawn(true)
    end
end)

-- Listen for map start
AddEventHandler('onClientMapStart', function(map)
    print('Map started: ' .. map)
end)

-- Listen for map stop
AddEventHandler('onClientMapStop', function(map)
    print('Map stopped: ' .. map)
end)
```

## Events

### Client Events

#### onClientGameTypeStart
Triggered when a game type starts.

```lua
AddEventHandler('onClientGameTypeStart', function(gameTypeName)
    print('Game type started: ' .. gameTypeName)

    -- Apply game type specific settings
    if gameTypeName == 'race' then
        -- Disable wanted level for races
        SetMaxWantedLevel(0)
    end
end)
```

#### onClientGameTypeStop
Triggered when a game type stops.

```lua
AddEventHandler('onClientGameTypeStop', function(gameTypeName)
    print('Game type stopped: ' .. gameTypeName)

    -- Revert settings
    if gameTypeName == 'race' then
        SetMaxWantedLevel(5)
    end
end)
```

#### onClientMapStart
Triggered when a map starts loading.

```lua
AddEventHandler('onClientMapStart', function(mapName)
    print('Map started: ' .. mapName)

    -- Load map-specific assets
    RequestModel(GetHashKey('prop_special'))
end)
```

#### onClientMapStop
Triggered when a map stops.

```lua
AddEventHandler('onClientMapStop', function(mapName)
    print('Map stopped: ' .. mapName)

    -- Clean up map-specific entities
end)
```

### Server Events

#### onGameTypeStarting
Triggered before a game type starts (server-side).

```lua
AddEventHandler('onGameTypeStarting', function(gameTypeName)
    print('Game type starting: ' .. gameTypeName)
end)
```

#### onGameTypeStarted
Triggered after a game type has started (server-side).

```lua
AddEventHandler('onGameTypeStarted', function(gameTypeName)
    print('Game type started: ' .. gameTypeName)

    TriggerClientEvent('chat:addMessage', -1, {
        args = {'Server', 'Game mode: ' .. gameTypeName}
    })
end)
```

#### onMapStarting
Triggered before a map starts loading (server-side).

```lua
AddEventHandler('onMapStarting', function(mapName)
    print('Map starting: ' .. mapName)
end)
```

#### onMapStarted
Triggered after a map has started (server-side).

```lua
AddEventHandler('onMapStarted', function(mapName)
    print('Map started: ' .. mapName)

    TriggerClientEvent('chat:addMessage', -1, {
        args = {'Server', 'Map loaded: ' .. mapName}
    })
end)
```

## Common Use Cases

### Automatic Map Rotation

```lua
-- Server-side
local mapRotation = {
    'fivem-map-skater',
    'fivem-map-hipster',
    'my-custom-map'
}
local currentMapIndex = 1

-- Rotate every 15 minutes
CreateThread(function()
    while true do
        Wait(900000) -- 15 minutes

        currentMapIndex = currentMapIndex + 1
        if currentMapIndex > #mapRotation then
            currentMapIndex = 1
        end

        local nextMap = mapRotation[currentMapIndex]
        exports.mapmanager:changeMap(nextMap)

        TriggerClientEvent('chat:addMessage', -1, {
            color = {0, 255, 0},
            args = {'Map Rotation', 'Now playing: ' .. nextMap}
        })
    end
end)
```

### Map Voting System

```lua
-- Server-side
local voteActive = false
local votes = {}

RegisterCommand('votenextmap', function(source)
    if not voteActive then
        voteActive = true
        votes = {}

        local maps = exports.mapmanager:getMaps()
        local mapList = table.concat(maps, ', ')

        TriggerClientEvent('chat:addMessage', -1, {
            args = {'Vote', 'Vote for next map: ' .. mapList}
        })

        SetTimeout(30000, function() -- 30 second vote
            local winner = nil
            local maxVotes = 0

            for map, count in pairs(votes) do
                if count > maxVotes then
                    maxVotes = count
                    winner = map
                end
            end

            if winner then
                exports.mapmanager:changeMap(winner)
                TriggerClientEvent('chat:addMessage', -1, {
                    args = {'Vote', 'Next map: ' .. winner}
                })
            end

            voteActive = false
        end)
    end
end)

RegisterCommand('vote', function(source, args)
    if voteActive and args[1] then
        votes[args[1]] = (votes[args[1]] or 0) + 1
        TriggerClientEvent('chat:addMessage', source, {
            args = {'Vote', 'You voted for: ' .. args[1]}
        })
    end
end)
```

### Game Mode with Custom Spawn Logic

```lua
-- Client-side (gamemode.lua)
AddEventHandler('onClientGameTypeStart', function(gameType)
    if gameType == 'arena' then
        -- Disable default spawn
        exports.spawnmanager:setAutoSpawn(false)

        -- Custom spawn handling
        SpawnPlayer()
    end
end)

function SpawnPlayer()
    local spawnPoints = {
        {x = 0.0, y = 0.0, z = 75.0},
        {x = 10.0, y = 10.0, z = 75.0},
        {x = -10.0, y = -10.0, z = 75.0}
    }

    local spawn = spawnPoints[math.random(#spawnPoints)]

    exports.spawnmanager:spawnPlayer({
        x = spawn.x,
        y = spawn.y,
        z = spawn.z,
        model = 'a_m_y_skater_01'
    }, function()
        -- Give weapons after spawn
        GiveWeaponToPed(PlayerPedId(), GetHashKey('weapon_pistol'), 100, false, true)
    end)
end
```

### Round-Based Game Mode

```lua
-- Server-side
local roundActive = false
local roundNumber = 0

function StartRound()
    roundActive = true
    roundNumber = roundNumber + 1

    TriggerClientEvent('chat:addMessage', -1, {
        color = {0, 255, 0},
        args = {'Round', 'Round ' .. roundNumber .. ' starting!'}
    })

    -- Round timer (5 minutes)
    SetTimeout(300000, function()
        EndRound()
    end)
end

function EndRound()
    if not roundActive then return end

    roundActive = false

    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        args = {'Round', 'Round ' .. roundNumber .. ' ended!'}
    })

    exports.mapmanager:roundEnded()

    -- Start next round after 10 seconds
    SetTimeout(10000, function()
        StartRound()
    end)
end

-- Start first round when game type starts
AddEventHandler('onGameTypeStarted', function(gameType)
    if gameType == 'rounds' then
        SetTimeout(5000, function()
            StartRound()
        end)
    end
end)
```

## Best Practices

1. **Always check map compatibility** before changing maps
2. **Clean up resources** when maps/game types stop
3. **Use events properly** to detect state changes
4. **Test map/game type combinations** thoroughly
5. **Provide feedback** to players when changing maps
6. **Handle errors gracefully** if map/game type doesn't exist
7. **Document compatible game types** in map files
8. **Use round system** for competitive game modes

## Troubleshooting

**Map not loading:**
- Ensure map resource is started
- Check fxmanifest.lua has `map 'map.lua'`
- Verify map file syntax is correct

**Game type not changing:**
- Check if game type resource exists
- Ensure mapmanager is running
- Verify game type name is correct

**Incompatible map/game type:**
- Use doesMapSupportGameType() to validate
- Check map's gameTypes array
- Ensure both resources are compatible

**Events not firing:**
- Check event names are exact
- Ensure you're listening on correct side (client/server)
- Verify mapmanager is started before your resource

## Related Resources

- **spawnmanager** - Handles player spawning
- **sessionmanager** - Manages player sessions
- **basic-gamemode** - Example game mode

## Official Links

- **Documentation:** https://docs.fivem.net/docs/resources/mapmanager/
- **Source Code:** Part of cfx-server-data
- **Forums:** https://forum.cfx.re/
