-- Admin System Server Script
print("^2[Admin-System]^7 Server script loaded")

-- Check if player is admin
function IsAdmin(source)
    local identifiers = GetPlayerIdentifiers(source)

    for _, identifier in pairs(identifiers) do
        for _, adminId in pairs(Config.Admins) do
            if identifier == adminId then
                return true
            end
        end
    end

    return false
end

-- Get admin permission level
function GetAdminLevel(source)
    local identifiers = GetPlayerIdentifiers(source)

    for _, identifier in pairs(identifiers) do
        if Config.AdminLevels[identifier] then
            return Config.AdminLevels[identifier]
        end
    end

    -- Default admin level if in admin list but no specific level
    if IsAdmin(source) then
        return Config.Permissions.moderator
    end

    return 0
end

-- Check if player has permission for command
function HasPermission(source, command)
    local level = GetAdminLevel(source)
    local required = Config.CommandPermissions[command] or 999

    return level >= required
end

-- Send message to player
function SendMessage(source, message, type)
    local color = {255, 255, 255}
    if type == "error" then
        color = {255, 0, 0}
    elseif type == "success" then
        color = {0, 255, 0}
    elseif type == "info" then
        color = {0, 150, 255}
    end

    TriggerClientEvent('chat:addMessage', source, {
        color = color,
        args = {'[Admin]', message}
    })
end

-- Player Management Commands

-- Kick player
RegisterCommand('kick', function(source, args, rawCommand)
    if not HasPermission(source, 'kick') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        SendMessage(source, 'Usage: /kick [id] [reason]', 'error')
        return
    end

    local reason = table.concat(args, ' ', 2) or 'No reason provided'

    DropPlayer(targetId, 'Kicked by admin: ' .. reason)
    SendMessage(source, 'Player kicked: ' .. GetPlayerName(targetId), 'success')
end, false)

-- Teleport to player
RegisterCommand('goto', function(source, args, rawCommand)
    if not HasPermission(source, 'goto') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        SendMessage(source, 'Usage: /goto [id]', 'error')
        return
    end

    TriggerClientEvent('admin:teleportToPlayer', source, targetId)
    SendMessage(source, 'Teleporting to ' .. GetPlayerName(targetId), 'success')
end, false)

-- Bring player to you
RegisterCommand('bring', function(source, args, rawCommand)
    if not HasPermission(source, 'bring') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        SendMessage(source, 'Usage: /bring [id]', 'error')
        return
    end

    TriggerClientEvent('admin:bringPlayer', targetId, source)
    SendMessage(source, 'Bringing ' .. GetPlayerName(targetId) .. ' to you', 'success')
end, false)

-- Freeze player
RegisterCommand('freeze', function(source, args, rawCommand)
    if not HasPermission(source, 'freeze') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        SendMessage(source, 'Usage: /freeze [id]', 'error')
        return
    end

    TriggerClientEvent('admin:freezePlayer', targetId)
    SendMessage(source, 'Toggled freeze for ' .. GetPlayerName(targetId), 'success')
end, false)

-- Heal player
RegisterCommand('heal', function(source, args, rawCommand)
    if not HasPermission(source, 'heal') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1]) or source

    TriggerClientEvent('admin:healPlayer', targetId)

    if targetId == source then
        SendMessage(source, 'You healed yourself', 'success')
    else
        SendMessage(source, 'Healed ' .. GetPlayerName(targetId), 'success')
        SendMessage(targetId, 'You were healed by an admin', 'info')
    end
end, false)

-- Give armor
RegisterCommand('armor', function(source, args, rawCommand)
    if not HasPermission(source, 'armor') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1]) or source

    TriggerClientEvent('admin:armorPlayer', targetId)

    if targetId == source then
        SendMessage(source, 'You gave yourself armor', 'success')
    else
        SendMessage(source, 'Gave armor to ' .. GetPlayerName(targetId), 'success')
        SendMessage(targetId, 'You received armor from an admin', 'info')
    end
end, false)

-- Announce message
RegisterCommand('announce', function(source, args, rawCommand)
    if not HasPermission(source, 'announce') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local message = table.concat(args, ' ')
    if not message or message == '' then
        SendMessage(source, 'Usage: /announce [message]', 'error')
        return
    end

    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 165, 0},
        multiline = true,
        args = {'[ANNOUNCEMENT]', message}
    })

    SendMessage(source, 'Announcement sent', 'success')
end, false)

-- List online players
RegisterCommand('players', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local players = GetPlayers()
    SendMessage(source, 'Online players (' .. #players .. '):', 'info')

    for _, playerId in ipairs(players) do
        local id = tonumber(playerId)
        SendMessage(source, '[' .. id .. '] ' .. GetPlayerName(id), 'info')
    end
end, false)

-- Teleport to coordinates
RegisterCommand('tp', function(source, args, rawCommand)
    if not HasPermission(source, 'teleport') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])

    if not x or not y or not z then
        SendMessage(source, 'Usage: /tp [x] [y] [z]', 'error')
        return
    end

    TriggerClientEvent('admin:teleportToCoords', source, x, y, z)
    SendMessage(source, 'Teleported to coordinates', 'success')
end, false)

-- Spawn vehicle
RegisterCommand('car', function(source, args, rawCommand)
    if not HasPermission(source, 'spawnvehicle') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local model = args[1]
    if not model then
        SendMessage(source, 'Usage: /car [model]', 'error')
        return
    end

    TriggerClientEvent('admin:spawnVehicle', source, model)
end, false)

-- Delete vehicle
RegisterCommand('dv', function(source, args, rawCommand)
    if not HasPermission(source, 'deletevehicle') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    TriggerClientEvent('admin:deleteVehicle', source)
    SendMessage(source, 'Vehicle deleted', 'success')
end, false)

-- Fix vehicle
RegisterCommand('fix', function(source, args, rawCommand)
    if not HasPermission(source, 'fixvehicle') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    TriggerClientEvent('admin:fixVehicle', source)
    SendMessage(source, 'Vehicle fixed', 'success')
end, false)

-- Weather command
RegisterCommand('weather', function(source, args, rawCommand)
    if not HasPermission(source, 'weather') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local weather = args[1]
    if not weather then
        SendMessage(source, 'Usage: /weather [type]', 'error')
        return
    end

    TriggerClientEvent('admin:setWeather', -1, weather:upper())
    SendMessage(source, 'Weather set to ' .. weather, 'success')
end, false)

-- Time command
RegisterCommand('time', function(source, args, rawCommand)
    if not HasPermission(source, 'time') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local hour = tonumber(args[1])
    local minute = tonumber(args[2]) or 0

    if not hour then
        SendMessage(source, 'Usage: /time [hour] [minute]', 'error')
        return
    end

    TriggerClientEvent('admin:setTime', -1, hour, minute)
    SendMessage(source, 'Time set to ' .. hour .. ':' .. minute, 'success')
end, false)

-- Admin menu
RegisterCommand('admin', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    TriggerClientEvent('admin:openMenu', source)
end, false)

-- Check admin on connect
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source

    Wait(500)

    if IsAdmin(source) then
        local level = GetAdminLevel(source)
        local levelName = 'Moderator'

        if level == Config.Permissions.admin then
            levelName = 'Admin'
        elseif level == Config.Permissions.superadmin then
            levelName = 'Super Admin'
        end

        print("^2[Admin-System]^7 Admin connected: " .. name .. " (" .. levelName .. ")")
    end
end)

print("^2[Admin-System]^7 Loaded " .. #Config.Admins .. " admin(s)")
