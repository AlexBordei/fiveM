-- Player Persistence Client Script
print("^2[Player-Persistence]^7 Client script loaded")

local hasSpawned = false
local saveInterval = 30000 -- Save every 30 seconds

-- Save current position to server
local function SavePosition()
    local ped = PlayerPedId()

    if not DoesEntityExist(ped) then return end

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    TriggerServerEvent('player-persistence:savePosition', coords.x, coords.y, coords.z, heading)
end

-- Override spawn manager to use last position
CreateThread(function()
    -- Wait for spawnmanager to load
    while GetResourceState('spawnmanager') ~= 'started' do
        Wait(100)
    end

    -- Set custom spawn callback
    exports.spawnmanager:setAutoSpawnCallback(function()
        -- Request last position from server
        TriggerServerEvent('player-persistence:getLastPosition')
    end)

    -- Disable auto-spawn, we'll handle it manually
    exports.spawnmanager:setAutoSpawn(false)
end)

-- Receive last position from server
RegisterNetEvent('player-persistence:receiveLastPosition')
AddEventHandler('player-persistence:receiveLastPosition', function(position)
    if hasSpawned then return end
    hasSpawned = true

    if position and position.x and position.y and position.z then
        -- Spawn at last position
        print("^2[Player-Persistence]^7 Spawning at last position")

        exports.spawnmanager:spawnPlayer({
            x = position.x,
            y = position.y,
            z = position.z,
            heading = position.heading or 0.0,
            skipFade = false
        }, function()
            -- Spawn complete
            print("^2[Player-Persistence]^7 Spawned successfully")

            -- Start auto-save
            StartAutoSave()
        end)
    else
        -- No saved position, use default spawn or character creator
        print("^2[Player-Persistence]^7 No saved position, using default spawn")

        -- Check if character-creator exists
        if GetResourceState('character-creator') == 'started' then
            -- Let character creator handle the spawn
            TriggerEvent('character-creator:start')
        else
            -- Default spawn
            exports.spawnmanager:spawnPlayer({
                x = -269.4,
                y = -955.3,
                z = 31.2,
                heading = 206.0,
                model = 'a_m_y_skater_01'
            }, function()
                print("^2[Player-Persistence]^7 Spawned at default location")
                StartAutoSave()
            end)
        end
    end
end)

-- Start automatic position saving
function StartAutoSave()
    CreateThread(function()
        while true do
            Wait(saveInterval)
            SavePosition()
        end
    end)
end

-- Save position when resource stops
AddEventHandler('onClientResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SavePosition()
        print("^2[Player-Persistence]^7 Saved position before resource stop")
    end
end)

-- Player settings management
local playerSettings = {
    volume = 1.0,
    hud = true,
    notifications = true,
    -- Add more settings as needed
}

-- Save player settings
local function SaveSettings()
    TriggerServerEvent('player-persistence:saveSettings', playerSettings)
end

-- Load player settings
RegisterNetEvent('player-persistence:receiveSettings')
AddEventHandler('player-persistence:receiveSettings', function(settings)
    if settings then
        playerSettings = settings
        print("^2[Player-Persistence]^7 Loaded player settings")

        -- Apply settings
        ApplySettings()
    end
end)

-- Apply loaded settings
function ApplySettings()
    -- Apply volume, HUD visibility, etc.
    -- Example: SetAudioFlag('DisableFlightMusic', not playerSettings.volume)

    print("^2[Player-Persistence]^7 Applied player settings")
end

-- Request settings on resource start
CreateThread(function()
    Wait(2000) -- Wait for player to fully load
    TriggerServerEvent('player-persistence:getSettings')
end)

-- Commands for testing
RegisterCommand('savepos', function()
    SavePosition()
    print("^2[Player-Persistence]^7 Position saved manually")
end, false)

RegisterCommand('getpos', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    print(string.format("^2[Player-Persistence]^7 Current position: x=%.2f, y=%.2f, z=%.2f, heading=%.2f",
        coords.x, coords.y, coords.z, heading))
end, false)

-- Export functions
exports('SavePosition', SavePosition)
exports('SaveSettings', SaveSettings)
exports('GetSettings', function() return playerSettings end)
exports('SetSetting', function(key, value)
    playerSettings[key] = value
    SaveSettings()
end)
