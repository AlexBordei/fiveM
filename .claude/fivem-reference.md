# FiveM Quick Reference Guide

## Official Documentation Links

- **Main Docs:** https://docs.fivem.net/docs/
- **Server Manual:** https://docs.fivem.net/docs/server-manual/setting-up-a-server/
- **Scripting Introduction:** https://docs.fivem.net/docs/scripting-manual/introduction/
- **Resource Creation:** https://docs.fivem.net/docs/scripting-manual/introduction/creating-your-first-script/
- **Native Functions:** https://docs.fivem.net/natives/
- **Server Commands:** https://docs.fivem.net/docs/server-manual/server-commands/

## Resource Manifest (fxmanifest.lua)

### Basic Template
```lua
fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Resource Description'
version '1.0.0'

-- Client scripts
client_scripts {
    'client.lua'
}

-- Server scripts
server_scripts {
    'server.lua'
}

-- Shared scripts (run on both)
shared_scripts {
    'config.lua'
}

-- Files to download to client
files {
    'html/index.html'
}

-- UI page
ui_page 'html/index.html'
```

### FX Versions
- `cerulean` - Latest features (recommended)
- `bodacious` - Older version
- `adamant` - Legacy

## Server-Side Scripting

### Commands
```lua
-- Register command
RegisterCommand('commandname', function(source, args, rawCommand)
    local playerId = source  -- Player who executed command
    local arg1 = args[1]     -- First argument

    -- Send message to player
    TriggerClientEvent('chat:addMessage', playerId, {
        args = {'Server', 'Hello!'}
    })
end, false)

-- Restricted command (requires ace permission)
RegisterCommand('admin', function(source, args)
    -- Admin only command
end, true)
```

### Events
```lua
-- Built-in events
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    deferrals.defer()

    -- Do async checks
    Wait(0)

    deferrals.update('Checking whitelist...')

    -- Allow or deny
    deferrals.done()
    -- deferrals.done('Kick reason')
end)

AddEventHandler('playerJoining', function()
    local source = source
    print('Player ' .. GetPlayerName(source) .. ' is joining')
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    print('Player ' .. GetPlayerName(source) .. ' left: ' .. reason)
end)

-- Custom events
RegisterNetEvent('myResource:serverEvent')
AddEventHandler('myResource:serverEvent', function(data)
    local source = source
    -- Handle event
end)
```

### Player Functions
```lua
-- Get player name
local name = GetPlayerName(source)

-- Get player identifiers
local identifiers = GetPlayerIdentifiers(source)
for k, v in pairs(identifiers) do
    if string.match(v, 'steam:') then
        local steamId = v
    end
end

-- Get specific identifier
local steamId = GetPlayerIdentifier(source, 0)  -- steam:
local license = GetPlayerIdentifier(source, 1)  -- license:

-- Get player endpoint (IP)
local endpoint = GetPlayerEndpoint(source)

-- Get player ping
local ping = GetPlayerPing(source)

-- Get number of players
local numPlayers = GetNumPlayerIndices()

-- Get all players
local players = GetPlayers()
for _, playerId in ipairs(players) do
    print(GetPlayerName(playerId))
end

-- Drop player (kick)
DropPlayer(source, 'Kick reason')
```

### Trigger Events
```lua
-- Trigger event on specific client
TriggerClientEvent('eventName', source, arg1, arg2)

-- Trigger event on all clients
TriggerClientEvent('eventName', -1, arg1, arg2)

-- Trigger server event
TriggerEvent('serverEvent', arg1, arg2)
```

### HTTP Requests
```lua
PerformHttpRequest('https://api.example.com/endpoint', function(errorCode, resultData, resultHeaders)
    if errorCode == 200 then
        local data = json.decode(resultData)
        -- Handle data
    end
end, 'POST', json.encode({key = 'value'}), {['Content-Type'] = 'application/json'})
```

### Database (MySQL)
```lua
-- Assuming mysql-async resource
MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
    ['@identifier'] = identifier
}, function(result)
    if result[1] then
        -- Found user
    end
end)

MySQL.Async.execute('INSERT INTO users (identifier, name) VALUES (@identifier, @name)', {
    ['@identifier'] = identifier,
    ['@name'] = name
}, function(affectedRows)
    print('Inserted ' .. affectedRows .. ' rows')
end)
```

## Client-Side Scripting

### Commands
```lua
RegisterCommand('coords', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    print(string.format('X: %.2f, Y: %.2f, Z: %.2f, H: %.2f',
        coords.x, coords.y, coords.z, heading))
end, false)
```

### Events
```lua
-- Register client event
RegisterNetEvent('myResource:clientEvent')
AddEventHandler('myResource:clientEvent', function(data)
    -- Handle event
end)

-- Resource start
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('My resource started')
    end
end)

-- Resource stop
AddEventHandler('onClientResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('My resource stopped')
    end
end)
```

### Threads
```lua
-- Create thread
CreateThread(function()
    while true do
        Wait(0)  -- Important! Wait at least 0ms

        -- Do something every frame
    end
end)

-- Better: Only run when needed
CreateThread(function()
    while true do
        Wait(1000)  -- Run every second

        -- Do something
    end
end)
```

### Player/Ped Functions
```lua
-- Get player ped
local ped = PlayerPedId()

-- Get player ID
local playerId = PlayerId()

-- Get player coordinates
local coords = GetEntityCoords(ped)

-- Get player heading
local heading = GetEntityHeading(ped)

-- Teleport player
SetEntityCoords(ped, x, y, z, false, false, false, true)

-- Set player heading
SetEntityHeading(ped, heading)

-- Check if in vehicle
if IsPedInAnyVehicle(ped, false) then
    local vehicle = GetVehiclePedIsIn(ped, false)
end

-- Get health
local health = GetEntityHealth(ped)
local maxHealth = GetEntityMaxHealth(ped)

-- Set health
SetEntityHealth(ped, 200)
```

### Vehicle Functions
```lua
-- Get current vehicle
local vehicle = GetVehiclePedIsIn(ped, false)

-- Get last vehicle
local lastVehicle = GetVehiclePedIsIn(ped, true)

-- Spawn vehicle
local hash = GetHashKey('adder')
RequestModel(hash)
while not HasModelLoaded(hash) do
    Wait(0)
end

local vehicle = CreateVehicle(hash, x, y, z, heading, true, false)
SetPedIntoVehicle(ped, vehicle, -1)

-- Delete vehicle
DeleteVehicle(vehicle)

-- Vehicle properties
local plate = GetVehicleNumberPlateText(vehicle)
SetVehicleNumberPlateText(vehicle, 'MYPLATE')

local fuel = GetVehicleFuelLevel(vehicle)
SetVehicleFuelLevel(vehicle, 100.0)

local engineHealth = GetVehicleEngineHealth(vehicle)
SetVehicleEngineHealth(vehicle, 1000.0)
```

### UI/NUI
```lua
-- Send message to NUI
SendNUIMessage({
    type = 'show',
    data = {
        text = 'Hello from Lua!'
    }
})

-- Register NUI callback
RegisterNUICallback('buttonClick', function(data, cb)
    print('Button clicked with data: ' .. json.encode(data))

    -- Send response back to NUI
    cb({success = true})
end)

-- Set NUI focus
SetNuiFocus(true, true)  -- hasFocus, hasCursor
```

## Server Configuration (server.cfg)

### Essential Settings
```cfg
# Server info
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"
sv_hostname "Server Name"
sv_maxclients 32

# License
sv_licenseKey "YOUR_KEY_HERE"

# OneSync (required for 32+ players)
set onesync on

# Server tags
sets tags "roleplay, custom"

# Locale
sets locale "en-US"

# Resources
ensure resourcename
```

### Convars
```cfg
# Set variable
set my_variable "value"
setr my_variable "value"  # replicated to clients
sets my_variable "value"  # server info

# Access in resource
local value = GetConvar('my_variable', 'defaultValue')
```

## Server Commands (Console/RCON)

```
# Resource management
refresh           # Refresh resource list
start [resource]  # Start resource
stop [resource]   # Stop resource
restart [resource]# Restart resource
ensure [resource] # Start if not running

# Server management
quit              # Stop server
status            # Show server status

# Player management
clientkick [id] [reason]
tempbanclient [id] [reason]

# Permissions
add_ace [principal] [ace] [allow/deny]
add_principal [child] [parent]
```

## Common Natives

Refer to: https://docs.fivem.net/natives/

### Categories
- **PLAYER** - Player-related functions
- **PED** - Pedestrian functions
- **VEHICLE** - Vehicle functions
- **ENTITY** - Entity management
- **WEAPON** - Weapon functions
- **STREAMING** - Model/texture loading
- **UI** - User interface
- **GRAPHICS** - Visual effects
- **AUDIO** - Sound functions

## Best Practices

1. **Always use Wait()** in loops to prevent server freeze
2. **Use threads efficiently** - don't run heavy operations every frame
3. **Validate input** on server side, never trust client
4. **Use events properly** - RegisterNetEvent for networked events
5. **Clean up resources** - delete entities, stop threads on resource stop
6. **Use proper resource structure** - separate client/server/shared code
7. **Follow naming conventions** - use camelCase for variables, PascalCase for functions
8. **Document your code** - add comments explaining complex logic
9. **Test thoroughly** - test on both client and server
10. **Handle errors** - use pcall() for error-prone code

## Debugging

```lua
-- Client console
print('Debug message')
print(json.encode(table, {indent = true}))

-- Server console
print('Server log')

-- Client notifications
TriggerEvent('chat:addMessage', {
    args = {'Debug', 'Message'}
})
```

## Common Errors

**"Couldn't find resource"**
- Resource not in resources folder
- Resource name doesn't match folder name
- fxmanifest.lua missing

**"Resource is already running"**
- Restart instead of start
- Check for duplicate ensure statements

**"Access denied"**
- Client trying to use server-only functions
- Missing ace permissions

**Server freezes**
- Missing Wait() in loop
- Infinite loop without break

## Additional Resources

- **Community Resources:** https://forum.cfx.re/c/development/releases
- **ESX Framework:** https://github.com/esx-framework
- **QBCore Framework:** https://github.com/qbcore-framework
- **Discord:** https://discord.gg/fivem
