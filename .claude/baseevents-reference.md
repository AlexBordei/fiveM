# FiveM Baseevents Resource Reference

**Documentation:** https://docs.fivem.net/docs/resources/baseevents/

## Overview

Baseevents is a fundamental FiveM resource that provides basic event triggers for common gameplay actions. Many third-party resources depend on baseevents, so it should be started in your server.cfg:

```cfg
ensure baseevents
```

## Available Events

### Death Events

#### onPlayerDied
Triggered when a player dies (both client and server side).

**Client-Side:**
```lua
AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
    -- killerType: Type of killer (integer)
    -- deathCoords: Coordinates where death occurred (vector3)

    print('Player died at: ' .. json.encode(deathCoords))
end)
```

**Server-Side:**
```lua
AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
    local source = source
    print('Player ' .. GetPlayerName(source) .. ' died')
end)
```

#### onPlayerKilled
Triggered when a player is killed by another player/entity.

**Client-Side:**
```lua
AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    -- killerId: Entity ID of the killer
    -- deathData: Additional death information

    local killerName = GetPlayerName(GetPlayerFromServerId(killerId))
    print('Killed by: ' .. killerName)
end)
```

**Server-Side:**
```lua
AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local victim = source
    print('Player ' .. GetPlayerName(victim) .. ' was killed by ' .. GetPlayerName(killerId))
end)
```

#### onPlayerWasted
Triggered when a player is "wasted" (GTA-style death).

**Client-Side:**
```lua
AddEventHandler('baseevents:onPlayerWasted', function(wastedCoords)
    -- wastedCoords: Coordinates where wasted (vector3)

    print('Player wasted at: ' .. json.encode(wastedCoords))
end)
```

**Server-Side:**
```lua
AddEventHandler('baseevents:onPlayerWasted', function(wastedCoords)
    local source = source
    print('Player ' .. GetPlayerName(source) .. ' was wasted')
end)
```

### Vehicle Events (Server-Side Only)

#### enteringVehicle
Triggered when a player starts entering a vehicle.

```lua
AddEventHandler('baseevents:enteringVehicle', function(vehicle, seat, displayName)
    local source = source
    -- vehicle: Vehicle entity handle
    -- seat: Seat number (-1 = driver, 0+ = passenger)
    -- displayName: Vehicle display name

    print('Player entering ' .. displayName .. ' in seat ' .. seat)
end)
```

#### enteringAborted
Triggered when a player cancels entering a vehicle.

```lua
AddEventHandler('baseevents:enteringAborted', function()
    local source = source
    print('Player cancelled entering vehicle')
end)
```

#### enteredVehicle
Triggered when a player successfully enters a vehicle.

```lua
AddEventHandler('baseevents:enteredVehicle', function(vehicle, seat, displayName)
    local source = source
    -- vehicle: Vehicle entity handle
    -- seat: Seat number (-1 = driver, 0+ = passenger)
    -- displayName: Vehicle display name

    print('Player entered ' .. displayName .. ' in seat ' .. seat)
end)
```

#### leftVehicle
Triggered when a player exits a vehicle.

```lua
AddEventHandler('baseevents:leftVehicle', function(vehicle, seat, displayName)
    local source = source
    -- vehicle: Vehicle entity handle
    -- seat: Seat number they left from
    -- displayName: Vehicle display name

    print('Player left ' .. displayName)
end)
```

## Common Use Cases

### Death Logging System
```lua
-- Server-side
AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local victim = source
    local victimName = GetPlayerName(victim)
    local killerName = GetPlayerName(killerId)

    -- Log to database
    MySQL.Async.execute('INSERT INTO death_logs (victim, killer, timestamp) VALUES (@victim, @killer, NOW())', {
        ['@victim'] = victimName,
        ['@killer'] = killerName
    })

    -- Notify all players
    TriggerClientEvent('chat:addMessage', -1, {
        args = {'Death', killerName .. ' killed ' .. victimName}
    })
end)
```

### Respawn System
```lua
-- Client-side
AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
    -- Wait for respawn
    Wait(5000)

    -- Respawn at hospital
    local hospitalCoords = vector3(298.67, -584.54, 43.29)

    SetEntityCoords(PlayerPedId(), hospitalCoords.x, hospitalCoords.y, hospitalCoords.z)
    NetworkResurrectLocalPlayer(hospitalCoords.x, hospitalCoords.y, hospitalCoords.z, 0.0, true, false)

    -- Restore health
    SetEntityHealth(PlayerPedId(), 200)
end)
```

### Vehicle Entry Restrictions
```lua
-- Server-side
local restrictedVehicles = {
    'police',
    'police2',
    'police3',
    'ambulance',
    'firetruk'
}

AddEventHandler('baseevents:enteringVehicle', function(vehicle, seat, displayName)
    local source = source
    local model = GetEntityModel(vehicle)
    local modelName = GetDisplayNameFromVehicleModel(model):lower()

    for _, restricted in ipairs(restrictedVehicles) do
        if modelName == restricted then
            -- Check if player has permission
            if not IsPlayerAceAllowed(source, 'vehicle.emergency') then
                CancelEvent()
                TriggerClientEvent('chat:addMessage', source, {
                    args = {'Vehicle', 'You cannot enter this vehicle!'}
                })

                -- Eject player
                TaskLeaveVehicle(GetPlayerPed(source), vehicle, 16)
            end
        end
    end
end)
```

### Vehicle Entry/Exit Tracking
```lua
-- Server-side
local playersInVehicles = {}

AddEventHandler('baseevents:enteredVehicle', function(vehicle, seat, displayName)
    local source = source
    playersInVehicles[source] = {
        vehicle = vehicle,
        seat = seat,
        displayName = displayName,
        enterTime = os.time()
    }

    print(GetPlayerName(source) .. ' entered ' .. displayName)
end)

AddEventHandler('baseevents:leftVehicle', function(vehicle, seat, displayName)
    local source = source

    if playersInVehicles[source] then
        local timeInVehicle = os.time() - playersInVehicles[source].enterTime
        print(GetPlayerName(source) .. ' was in vehicle for ' .. timeInVehicle .. ' seconds')

        playersInVehicles[source] = nil
    end
end)

-- Clean up on player disconnect
AddEventHandler('playerDropped', function()
    local source = source
    playersInVehicles[source] = nil
end)
```

### Kill/Death Ratio Tracker
```lua
-- Server-side
local playerStats = {}

AddEventHandler('playerConnecting', function()
    local source = source
    playerStats[source] = {
        kills = 0,
        deaths = 0
    }
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local victim = source

    -- Increment victim deaths
    if playerStats[victim] then
        playerStats[victim].deaths = playerStats[victim].deaths + 1
    end

    -- Increment killer kills
    if playerStats[killerId] then
        playerStats[killerId].kills = playerStats[killerId].kills + 1

        -- Notify killer
        local kd = playerStats[killerId].kills / math.max(playerStats[killerId].deaths, 1)
        TriggerClientEvent('chat:addMessage', killerId, {
            args = {'Stats', string.format('K/D: %.2f', kd)}
        })
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    playerStats[source] = nil
end)
```

## Important Notes

1. **Resource Dependency:** Ensure baseevents is started before resources that depend on it
2. **Server Performance:** Vehicle events are server-side only to reduce network traffic
3. **Event Cancellation:** Some events (like enteringVehicle) can be cancelled using `CancelEvent()`
4. **Client/Server:** Death events trigger on both client and server; vehicle events are server-only
5. **Death Types:** Different death types may have different killerType values

## Best Practices

1. Always check if player/entity exists before processing events
2. Clean up player-specific data on disconnect
3. Use appropriate event (onPlayerKilled vs onPlayerDied vs onPlayerWasted)
4. For vehicle events, validate seat numbers and vehicle handles
5. Log important events to database for analytics and moderation

## Troubleshooting

**Events not firing:**
- Ensure baseevents resource is started
- Check server.cfg has `ensure baseevents`
- Verify event handler syntax is correct

**Vehicle events not working:**
- Vehicle events are server-side only
- Ensure you're listening on server, not client

**Multiple death events firing:**
- This is normal - onPlayerDied, onPlayerKilled, and onPlayerWasted can all fire
- Choose the most appropriate event for your use case

## Related Resources

- **deathevents** - Part of baseevents, handles death detection
- **vehiclechecker** - Part of baseevents, handles vehicle events
- **Official Docs:** https://docs.fivem.net/docs/resources/baseevents/
