-- Character Creator Server Script
local characterData = {} -- In-memory storage (use database in production)

-- Save character data
RegisterNetEvent('character:save')
AddEventHandler('character:save', function(data)
    local source = source
    local playerName = GetPlayerName(source)

    -- Store character data
    characterData[source] = {
        firstName = data.firstName,
        lastName = data.lastName,
        dateOfBirth = data.dateOfBirth,
        model = data.model,
        heritage = data.heritage,
        spawnLocation = data.spawnLocation,
        created = os.time()
    }

    print(string.format("^2[Character]^7 %s created character: %s %s", playerName, data.firstName, data.lastName))

    -- Announce to server
    TriggerClientEvent('chat:addMessage', -1, {
        color = {0, 255, 0},
        args = {'Server', playerName .. ' has joined as ' .. data.firstName .. ' ' .. data.lastName}
    })

    -- TODO: Save to database
    -- Example:
    -- MySQL.Async.execute('INSERT INTO characters (identifier, firstname, lastname, dob, model, heritage) VALUES (@id, @first, @last, @dob, @model, @heritage)', {
    --     ['@id'] = GetPlayerIdentifier(source, 0),
    --     ['@first'] = data.firstName,
    --     ['@last'] = data.lastName,
    --     ['@dob'] = data.dateOfBirth,
    --     ['@model'] = data.model,
    --     ['@heritage'] = json.encode(data.heritage)
    -- })
end)

-- Request character data
RegisterNetEvent('character:requestData')
AddEventHandler('character:requestData', function()
    local source = source

    -- Check if player has character in memory
    if characterData[source] then
        TriggerClientEvent('character:receiveData', source, characterData[source])
    else
        -- TODO: Load from database
        -- Example:
        -- MySQL.Async.fetchAll('SELECT * FROM characters WHERE identifier = @id', {
        --     ['@id'] = GetPlayerIdentifier(source, 0)
        -- }, function(result)
        --     if result[1] then
        --         local data = {
        --             firstName = result[1].firstname,
        --             lastName = result[1].lastname,
        --             dateOfBirth = result[1].dob,
        --             model = result[1].model,
        --             heritage = json.decode(result[1].heritage)
        --         }
        --         TriggerClientEvent('character:receiveData', source, data)
        --     else
        --         TriggerClientEvent('character:receiveData', source, nil)
        --     end
        -- end)

        -- For now, no character found
        TriggerClientEvent('character:receiveData', source, nil)
    end
end)

-- Get character info command
RegisterCommand('charinfo', function(source, args)
    if characterData[source] then
        local char = characterData[source]
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 255},
            multiline = true,
            args = {'Character Info', string.format(
                'Name: %s %s\nDate of Birth: %s\nModel: %s',
                char.firstName, char.lastName, char.dateOfBirth, char.model
            )}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {'Error', 'No character found'}
        })
    end
end, false)

-- Admin command to delete character
RegisterCommand('chardelete', function(source, args)
    if args[1] then
        local targetId = tonumber(args[1])
        if characterData[targetId] then
            characterData[targetId] = nil
            TriggerClientEvent('chat:addMessage', source, {
                color = {0, 255, 0},
                args = {'Admin', 'Character deleted for player ' .. targetId}
            })
        end
    else
        -- Delete own character
        characterData[source] = nil
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            args = {'Success', 'Your character has been deleted. Reconnect to create a new one.'}
        })
    end
end, false)

-- Clean up on disconnect
AddEventHandler('playerDropped', function()
    local source = source
    -- Keep character data in memory
    -- In production, this would already be in database
    print(string.format("^3[Character]^7 Player %s disconnected", GetPlayerName(source)))
end)

-- Export functions
exports('getCharacterData', function(playerId)
    return characterData[playerId]
end)

exports('updateCharacterData', function(playerId, data)
    if characterData[playerId] then
        for k, v in pairs(data) do
            characterData[playerId][k] = v
        end
        return true
    end
    return false
end)
