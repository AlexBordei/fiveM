# FiveM Spawnmanager Resource Reference

**Documentation:** https://docs.fivem.net/docs/resources/spawnmanager/

## Overview

Spawnmanager is a foundational resource that manages player spawning mechanics. It allows developers to control when and where players spawn, as well as how they respawn after death.

**Repository:** Part of cfx-server-data

## Installation

Spawnmanager is included in default resources. Ensure it's started in your server.cfg:

```cfg
ensure spawnmanager
```

**Important:** If using with mapmanager, ensure mapmanager loads first:

```cfg
ensure mapmanager
ensure spawnmanager
```

## Client-Side Exports

All exports are called using: `exports.spawnmanager:exportName(args)`

### spawnPlayer(spawnOptions, callback)

Initiates player spawning at designated locations.

```lua
-- Basic spawn
exports.spawnmanager:spawnPlayer({
    x = 0.0,
    y = 0.0,
    z = 72.0,
    heading = 0.0,
    model = 'a_m_y_skater_01',
    skipFade = false
})

-- With callback
exports.spawnmanager:spawnPlayer({
    x = 100.0,
    y = 200.0,
    z = 72.0,
    heading = 180.0
}, function()
    print('Player spawned!')

    -- Give player weapons
    GiveWeaponToPed(PlayerPedId(), GetHashKey('weapon_pistol'), 100, false, true)

    -- Set player health
    SetEntityHealth(PlayerPedId(), 200)
end)

-- Spawn at random spawn point (if spawn points added)
exports.spawnmanager:spawnPlayer()
```

**Parameters:**
- `spawnOptions` (table, optional):
  - `x`, `y`, `z`: Coordinates
  - `heading`: Player direction (0-360)
  - `model`: Ped model to use
  - `skipFade`: Skip screen fade effect (boolean)
- `callback` (function, optional): Called after spawn completes

### addSpawnPoint(spawnPoint)

Registers new spawn locations for use.

```lua
-- Add single spawn point
exports.spawnmanager:addSpawnPoint({
    x = 0.0,
    y = 0.0,
    z = 72.0,
    heading = 0.0,
    model = 'a_m_y_skater_01'
})

-- Add multiple spawn points
local spawnPoints = {
    {x = 0.0, y = 0.0, z = 72.0, heading = 0.0},
    {x = 100.0, y = 100.0, z = 72.0, heading = 90.0},
    {x = -100.0, y = -100.0, z = 72.0, heading = 180.0}
}

for _, spawn in ipairs(spawnPoints) do
    exports.spawnmanager:addSpawnPoint(spawn)
end

-- Add spawn point with custom properties
exports.spawnmanager:addSpawnPoint({
    x = 200.0,
    y = 200.0,
    z = 72.0,
    heading = 270.0,
    model = 'a_f_y_business_01',
    skipFade = true
})
```

### removeSpawnPoint(spawnPoint)

Deletes existing spawn points.

```lua
-- Remove specific spawn point (must match exactly)
local spawnPoint = {x = 0.0, y = 0.0, z = 72.0, heading = 0.0}
exports.spawnmanager:removeSpawnPoint(spawnPoint)

-- Example: Remove all spawn points and add new ones
CreateThread(function()
    -- Get all current spawns
    local spawns = exports.spawnmanager:getSpawnPoints() -- Not officially documented

    -- Remove each one
    for _, spawn in ipairs(spawns or {}) do
        exports.spawnmanager:removeSpawnPoint(spawn)
    end

    -- Add new spawn
    exports.spawnmanager:addSpawnPoint({
        x = 0.0,
        y = 0.0,
        z = 72.0
    })
end)
```

### loadSpawns(spawns)

Loads spawn configuration data.

```lua
-- Load multiple spawns at once
local spawns = {
    {idx = 1, x = 0.0, y = 0.0, z = 72.0, heading = 0.0},
    {idx = 2, x = 100.0, y = 100.0, z = 72.0, heading = 90.0},
    {idx = 3, x = -100.0, y = -100.0, z = 72.0, heading = 180.0}
}

exports.spawnmanager:loadSpawns(spawns)

-- Load spawns from external file
CreateThread(function()
    -- Fetch from server
    TriggerServerCallback('getSpawnPoints', function(spawns)
        exports.spawnmanager:loadSpawns(spawns)
    end)
end)
```

### setAutoSpawn(enabled)

Configures automatic respawn behavior.

```lua
-- Enable auto-spawn (default)
exports.spawnmanager:setAutoSpawn(true)

-- Disable auto-spawn (manual control)
exports.spawnmanager:setAutoSpawn(false)

-- Example: Disable for custom death handling
AddEventHandler('baseevents:onPlayerDied', function()
    exports.spawnmanager:setAutoSpawn(false)

    -- Show death screen
    Wait(5000)

    -- Custom respawn
    exports.spawnmanager:spawnPlayer({
        x = 0.0,
        y = 0.0,
        z = 72.0
    })

    -- Re-enable auto-spawn
    exports.spawnmanager:setAutoSpawn(true)
end)
```

### setAutoSpawnCallback(callback)

Sets custom logic for spawn events.

```lua
-- Set custom spawn logic
exports.spawnmanager:setAutoSpawnCallback(function()
    -- Custom spawn logic
    local spawnPoint = GetRandomSpawnPoint() -- Your function

    exports.spawnmanager:spawnPlayer({
        x = spawnPoint.x,
        y = spawnPoint.y,
        z = spawnPoint.z,
        heading = spawnPoint.heading
    }, function()
        -- Post-spawn logic
        print('Custom spawn complete')
    end)
end)

-- Example: Team-based spawns
local teamSpawns = {
    team1 = {{x = 0.0, y = 0.0, z = 72.0}},
    team2 = {{x = 100.0, y = 100.0, z = 72.0}}
}

exports.spawnmanager:setAutoSpawnCallback(function()
    local playerTeam = GetPlayerTeam() -- Your function
    local spawns = teamSpawns[playerTeam]
    local spawn = spawns[math.random(#spawns)]

    exports.spawnmanager:spawnPlayer(spawn)
end)

-- Example: Spawn at last position
exports.spawnmanager:setAutoSpawnCallback(function()
    TriggerServerEvent('getLastPosition', function(pos)
        if pos then
            exports.spawnmanager:spawnPlayer({
                x = pos.x,
                y = pos.y,
                z = pos.z
            })
        else
            -- Default spawn
            exports.spawnmanager:spawnPlayer()
        end
    end)
end)
```

### forceRespawn()

Manually triggers player respawn.

```lua
-- Force immediate respawn
exports.spawnmanager:forceRespawn()

-- Example: Admin command
RegisterCommand('respawn', function()
    exports.spawnmanager:forceRespawn()
end, false)

-- Example: Respawn after custom timer
AddEventHandler('baseevents:onPlayerDied', function()
    exports.spawnmanager:setAutoSpawn(false)

    -- Wait 10 seconds
    Wait(10000)

    -- Force respawn
    exports.spawnmanager:forceRespawn()

    exports.spawnmanager:setAutoSpawn(true)
end)
```

## Client Events

### playerSpawned

Fired when a player successfully spawns.

```lua
AddEventHandler('playerSpawned', function(spawn)
    -- spawn: Table with spawn data (if available)
    print('Player spawned!')

    -- Get player ped
    local ped = PlayerPedId()

    -- Set player properties
    SetPedDefaultComponentVariation(ped)
    SetEntityHealth(ped, 200)

    -- Give starting items
    GiveWeaponToPed(ped, GetHashKey('weapon_knife'), 1, false, true)

    -- Notification
    TriggerEvent('chat:addMessage', {
        args = {'System', 'Welcome to the server!'}
    })
end)

-- Example: Track spawn location
local lastSpawn = nil

AddEventHandler('playerSpawned', function(spawn)
    lastSpawn = spawn
    print('Spawned at: ' .. json.encode(spawn))
end)

-- Example: Trigger server event
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('playerSpawned', GetPlayerServerId(PlayerId()))
end)
```

## Common Use Cases

### Basic First Spawn

```lua
-- Client-side resource
CreateThread(function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        exports.spawnmanager:spawnPlayer({
            x = 0.0,
            y = 0.0,
            z = 72.0,
            heading = 0.0,
            model = 'a_m_y_skater_01'
        })
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)
```

### Multiple Spawn Locations

```lua
-- Add spawn points
local spawns = {
    {x = 0.0, y = 0.0, z = 72.0, heading = 0.0},
    {x = 100.0, y = 100.0, z = 72.0, heading = 90.0},
    {x = -100.0, y = -100.0, z = 72.0, heading = 180.0},
    {x = 200.0, y = 200.0, z = 72.0, heading = 270.0}
}

for _, spawn in ipairs(spawns) do
    exports.spawnmanager:addSpawnPoint(spawn)
end

-- Auto-spawn will randomly select from these points
exports.spawnmanager:setAutoSpawn(true)
```

### Custom Death/Respawn System

```lua
-- Disable auto-spawn
exports.spawnmanager:setAutoSpawn(false)

-- Handle deaths
AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
    -- Show death screen
    StartScreenEffect('DeathFailOut', 0, true)

    -- Wait 5 seconds
    Wait(5000)

    -- Stop death effect
    StopScreenEffect('DeathFailOut')

    -- Respawn at hospital
    local hospitals = {
        {x = 298.67, y = -584.54, z = 43.29, heading = 253.0},
        {x = -254.88, y = 6324.5, z = 32.58, heading = 315.0}
    }

    local nearestHospital = hospitals[1] -- Find nearest
    local distance = 99999
    local playerCoords = GetEntityCoords(PlayerPedId())

    for _, hospital in ipairs(hospitals) do
        local dist = #(playerCoords - vector3(hospital.x, hospital.y, hospital.z))
        if dist < distance then
            distance = dist
            nearestHospital = hospital
        end
    end

    exports.spawnmanager:spawnPlayer(nearestHospital, function()
        -- Heal player
        SetEntityHealth(PlayerPedId(), 200)
    end)
end)
```

### Job-Based Spawns

```lua
-- Server-side: Store player job
local playerJobs = {}

RegisterNetEvent('setPlayerJob')
AddEventHandler('setPlayerJob', function(job)
    playerJobs[source] = job
end)

RegisterNetEvent('getPlayerJob')
AddEventHandler('getPlayerJob', function()
    TriggerClientEvent('receivePlayerJob', source, playerJobs[source] or 'civilian')
end)

-- Client-side: Spawn based on job
local jobSpawns = {
    police = {x = 425.1, y = -979.5, z = 30.7, heading = 90.0},
    medic = {x = 298.6, y = -584.5, z = 43.3, heading = 253.0},
    civilian = {x = 0.0, y = 0.0, z = 72.0, heading = 0.0}
}

exports.spawnmanager:setAutoSpawnCallback(function()
    TriggerServerEvent('getPlayerJob')
end)

RegisterNetEvent('receivePlayerJob')
AddEventHandler('receivePlayerJob', function(job)
    local spawn = jobSpawns[job] or jobSpawns.civilian

    exports.spawnmanager:spawnPlayer(spawn, function()
        print('Spawned as ' .. job)
    end)
end)
```

### Save Last Position

```lua
-- Client-side
local function SavePosition()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    TriggerServerEvent('savePosition', coords.x, coords.y, coords.z, heading)
end

-- Save position every 30 seconds
CreateThread(function()
    while true do
        Wait(30000)
        SavePosition()
    end
end)

-- Save on disconnect
AddEventHandler('onClientResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SavePosition()
    end
end)

-- Spawn at last position
exports.spawnmanager:setAutoSpawnCallback(function()
    TriggerServerEvent('getLastPosition')
end)

RegisterNetEvent('receiveLastPosition')
AddEventHandler('receiveLastPosition', function(x, y, z, heading)
    if x and y and z then
        exports.spawnmanager:spawnPlayer({
            x = x,
            y = y,
            z = z,
            heading = heading or 0.0
        })
    else
        -- Default spawn
        exports.spawnmanager:spawnPlayer({
            x = 0.0,
            y = 0.0,
            z = 72.0
        })
    end
end)

-- Server-side
local playerPositions = {}

RegisterNetEvent('savePosition')
AddEventHandler('savePosition', function(x, y, z, heading)
    playerPositions[source] = {x = x, y = y, z = z, heading = heading}
end)

RegisterNetEvent('getLastPosition')
AddEventHandler('getLastPosition', function()
    local pos = playerPositions[source]
    if pos then
        TriggerClientEvent('receiveLastPosition', source, pos.x, pos.y, pos.z, pos.heading)
    else
        TriggerClientEvent('receiveLastPosition', source, nil)
    end
end)

AddEventHandler('playerDropped', function()
    -- Could save to database here
    playerPositions[source] = nil
end)
```

## Integration with Mapmanager

Spawnmanager automatically recognizes spawn points from mapmanager resources:

```lua
-- In map.lua
local spawns = {
    {x = 0.0, y = 0.0, z = 72.0, heading = 0.0},
    {x = 100.0, y = 100.0, z = 72.0, heading = 90.0}
}

-- Mapmanager will pass these to spawnmanager
-- No need to manually add spawn points
```

## Best Practices

1. **Always set auto-spawn callback** before enabling auto-spawn
2. **Clean up on resource stop** - reset auto-spawn if disabled
3. **Validate spawn coordinates** before spawning
4. **Use callbacks** for post-spawn actions (weapons, health, etc.)
5. **Handle edge cases** - what if no spawn points exist?
6. **Save player position** periodically for persistence
7. **Test spawn locations** - ensure they're safe and accessible
8. **Combine with baseevents** for death handling

## Troubleshooting

**Player not spawning:**
- Check if auto-spawn is enabled
- Verify spawn points are added
- Ensure spawnmanager is started
- Check for errors in F8 console

**Spawning at wrong location:**
- Verify spawn coordinates are correct
- Check if custom callback is interfering
- Ensure mapmanager loads before spawnmanager

**Respawn not working:**
- Check if auto-spawn is disabled
- Verify forceRespawn is being called
- Ensure death events are properly handled

**Multiple spawns:**
- Disable auto-spawn when handling manually
- Check for conflicting spawn callbacks
- Ensure only one spawn call per death

## Related Resources

- **mapmanager** - Provides spawn points from maps
- **baseevents** - Death event handling
- **sessionmanager** - Player session management

## Official Links

- **Documentation:** https://docs.fivem.net/docs/resources/spawnmanager/
- **Source Code:** Part of cfx-server-data
- **Forums:** https://forum.cfx.re/
