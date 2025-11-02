-- Player Persistence Server Script with File Storage
print("^2[Player-Persistence]^7 Resource started")

local dataPath = GetResourcePath(GetCurrentResourceName()) .. '/playerdata.json'

-- Load all player data from file
local function LoadAllData()
    local file = io.open(dataPath, 'r')
    if file then
        local content = file:read('*a')
        file:close()

        if content and #content > 0 then
            local success, data = pcall(json.decode, content)
            if success and data then
                print("^2[Player-Persistence]^7 Loaded " .. #data .. " player records from file")
                return data
            end
        end
    end

    print("^2[Player-Persistence]^7 No existing data file, starting fresh")
    return {}
end

-- Save all player data to file
local function SaveAllData(data)
    local file = io.open(dataPath, 'w')
    if file then
        file:write(json.encode(data, {indent = true}))
        file:close()
        return true
    end

    print("^2[Player-Persistence]^7 ERROR: Could not write to data file")
    return false
end

-- In-memory cache
local playerData = LoadAllData()

-- Save player data to storage
local function SavePlayerData(source, data)
    local identifier = GetPlayerIdentifier(source, 0)
    if not identifier then return end

    playerData[identifier] = data

    -- Write to file
    if SaveAllData(playerData) then
        print("^2[Player-Persistence]^7 Saved data for " .. GetPlayerName(source) .. " (ID: " .. identifier .. ")")
    end
end

-- Load player data from storage
local function LoadPlayerData(source)
    local identifier = GetPlayerIdentifier(source, 0)
    if not identifier then return nil end

    return playerData[identifier]
end

-- When player connects, load their data
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    Wait(500) -- Give time for identifiers to load

    local data = LoadPlayerData(source)

    if data then
        print("^2[Player-Persistence]^7 Loaded data for " .. name .. " (last saved: " .. (data.lastSaved or "never") .. ")")
    else
        print("^2[Player-Persistence]^7 No existing data for " .. name .. ", will create new record")
    end
end)

-- Save position event
RegisterNetEvent('player-persistence:savePosition')
AddEventHandler('player-persistence:savePosition', function(x, y, z, heading)
    local source = source
    local data = LoadPlayerData(source) or {}

    data.position = {
        x = x,
        y = y,
        z = z,
        heading = heading
    }
    data.lastSaved = os.date("%Y-%m-%d %H:%M:%S")
    data.lastPlayerName = GetPlayerName(source)

    SavePlayerData(source, data)
end)

-- Save player settings
RegisterNetEvent('player-persistence:saveSettings')
AddEventHandler('player-persistence:saveSettings', function(settings)
    local source = source
    local data = LoadPlayerData(source) or {}

    data.settings = settings
    data.lastSaved = os.date("%Y-%m-%d %H:%M:%S")
    data.lastPlayerName = GetPlayerName(source)

    SavePlayerData(source, data)
end)

-- Get last position
RegisterNetEvent('player-persistence:getLastPosition')
AddEventHandler('player-persistence:getLastPosition', function()
    local source = source
    local data = LoadPlayerData(source)

    if data and data.position then
        TriggerClientEvent('player-persistence:receiveLastPosition', source, data.position)
    else
        TriggerClientEvent('player-persistence:receiveLastPosition', source, nil)
    end
end)

-- Get player settings
RegisterNetEvent('player-persistence:getSettings')
AddEventHandler('player-persistence:getSettings', function()
    local source = source
    local data = LoadPlayerData(source)

    if data and data.settings then
        TriggerClientEvent('player-persistence:receiveSettings', source, data.settings)
    else
        TriggerClientEvent('player-persistence:receiveSettings', source, nil)
    end
end)

-- Save on disconnect
AddEventHandler('playerDropped', function(reason)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)

    if identifier and playerData[identifier] then
        playerData[identifier].lastDisconnect = os.date("%Y-%m-%d %H:%M:%S")
        playerData[identifier].disconnectReason = reason
        SaveAllData(playerData)
        print("^2[Player-Persistence]^7 Saved final data for " .. GetPlayerName(source) .. " on disconnect")
    end
end)

-- Auto-save every 5 minutes as backup
CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes
        SaveAllData(playerData)
        print("^2[Player-Persistence]^7 Auto-saved all player data")
    end
end)

-- Export functions for other resources
exports('SavePlayerData', SavePlayerData)
exports('LoadPlayerData', LoadPlayerData)

print("^2[Player-Persistence]^7 File storage initialized at: " .. dataPath)
