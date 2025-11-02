-- Player Persistence Client Script (Simplified - No Spawn Override)
print("^2[Player-Persistence]^7 Client script loaded")

local saveInterval = 30000 -- Save every 30 seconds
local autoSaveStarted = false

-- Save current position to server
local function SavePosition()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    TriggerServerEvent('player-persistence:savePosition', coords.x, coords.y, coords.z, heading)
end

-- Wait for player to spawn, then start auto-save
CreateThread(function()
    -- Wait for player to be spawned
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    -- Wait a bit more to ensure everything is loaded
    Wait(2000)

    print("^2[Player-Persistence]^7 Player spawned, starting auto-save")
    StartAutoSave()
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
