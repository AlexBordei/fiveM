-- Player Persistence Server Script
print("^2[Player-Persistence]^7 Resource started")

-- Storage for player data (in production, use a database)
local playerData = {}

-- Save player data to storage
local function SavePlayerData(source, data)
    local identifier = GetPlayerIdentifier(source, 0)
    if not identifier then return end

    playerData[identifier] = data

    -- TODO: Save to database in production
    -- Example: MySQL.Async.execute('UPDATE players SET data = @data WHERE identifier = @identifier', {
    --     ['@identifier'] = identifier,
    --     ['@data'] = json.encode(data)
    -- })

    print("^2[Player-Persistence]^7 Saved data for " .. GetPlayerName(source))
end

-- Load player data from storage
local function LoadPlayerData(source)
    local identifier = GetPlayerIdentifier(source, 0)
    if not identifier then return nil end

    -- TODO: Load from database in production
    -- Example: local result = MySQL.Sync.fetchAll('SELECT data FROM players WHERE identifier = @identifier', {
    --     ['@identifier'] = identifier
    -- })
    -- if result[1] then
    --     return json.decode(result[1].data)
    -- end

    return playerData[identifier]
end

-- When player connects, load their data
RegisterNetEvent('playerConnecting')
AddEventHandler('playerConnecting', function()
    local source = source
    local data = LoadPlayerData(source)

    if data then
        print("^2[Player-Persistence]^7 Loaded data for " .. GetPlayerName(source))
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
    data.lastSaved = os.time()

    SavePlayerData(source, data)
end)

-- Save player settings
RegisterNetEvent('player-persistence:saveSettings')
AddEventHandler('player-persistence:saveSettings', function(settings)
    local source = source
    local data = LoadPlayerData(source) or {}

    data.settings = settings
    data.lastSaved = os.time()

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
    -- Position is already being saved periodically, no need to save again
    print("^2[Player-Persistence]^7 Player " .. GetPlayerName(source) .. " disconnected")
end)

-- Export functions for other resources
exports('SavePlayerData', SavePlayerData)
exports('LoadPlayerData', LoadPlayerData)
