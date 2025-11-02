-- Admin System Server Script
print("^2[Admin-System]^7 Server script loaded")

-- Runtime admin list (can be modified without restart)
local runtimeAdmins = {}
local bannedPlayers = {}

-- Load admins from config
for _, adminId in pairs(Config.Admins) do
    runtimeAdmins[adminId] = Config.AdminLevels[adminId] or Config.Permissions.moderator
end

-- Load bans from file
local function LoadBans()
    local file = io.open(GetResourcePath(GetCurrentResourceName()) .. '/bans.json', 'r')
    if file then
        local content = file:read('*a')
        file:close()
        if content and #content > 0 then
            local success, data = pcall(json.decode, content)
            if success and data then
                bannedPlayers = data
                print("^2[Admin-System]^7 Loaded " .. #bannedPlayers .. " bans")
            end
        end
    end
end

-- Save bans to file
local function SaveBans()
    local file = io.open(GetResourcePath(GetCurrentResourceName()) .. '/bans.json', 'w')
    if file then
        file:write(json.encode(bannedPlayers, {indent = true}))
        file:close()
    end
end

LoadBans()

-- Check if player is banned
local function IsBanned(identifier)
    for _, ban in pairs(bannedPlayers) do
        if ban.identifier == identifier then
            return true, ban
        end
    end
    return false
end

-- Check if player is admin
function IsAdmin(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if runtimeAdmins[identifier] then
            return true
        end
    end
    return false
end

-- Get admin permission level
function GetAdminLevel(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if runtimeAdmins[identifier] then
            return runtimeAdmins[identifier]
        end
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

-- Get player identifier
function GetPlayerMainIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.match(identifier, "license:") then
            return identifier
        end
    end
    return identifiers[1]
end

-- Make admin command
RegisterCommand('makeadmin', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        SendMessage(source, 'Usage: /makeadmin [id] [level] (1=mod, 2=admin, 3=superadmin)', 'error')
        return
    end

    local level = tonumber(args[2]) or Config.Permissions.moderator
    local identifier = GetPlayerMainIdentifier(targetId)

    runtimeAdmins[identifier] = level
    SendMessage(source, 'Made ' .. GetPlayerName(targetId) .. ' an admin (level ' .. level .. ')', 'success')
    SendMessage(targetId, 'You are now an admin! Type /admin for commands', 'success')
end, false)

-- Remove admin
RegisterCommand('removeadmin', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        SendMessage(source, 'Usage: /removeadmin [id]', 'error')
        return
    end

    local identifier = GetPlayerMainIdentifier(targetId)
    runtimeAdmins[identifier] = nil
    SendMessage(source, 'Removed admin from ' .. GetPlayerName(targetId), 'success')
    SendMessage(targetId, 'Your admin privileges have been removed', 'info')
end, false)

-- Ban player
RegisterCommand('ban', function(source, args, rawCommand)
    if not HasPermission(source, 'ban') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        SendMessage(source, 'Usage: /ban [id] [reason]', 'error')
        return
    end

    local reason = table.concat(args, ' ', 2) or 'No reason provided'
    local identifier = GetPlayerMainIdentifier(targetId)
    local targetName = GetPlayerName(targetId)

    table.insert(bannedPlayers, {
        identifier = identifier,
        name = targetName,
        reason = reason,
        bannedBy = GetPlayerName(source),
        bannedAt = os.date("%Y-%m-%d %H:%M:%S")
    })

    SaveBans()

    DropPlayer(targetId, 'BANNED: ' .. reason)
    SendMessage(source, 'Banned ' .. targetName .. ' - Reason: ' .. reason, 'success')

    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        args = {'[BAN]', targetName .. ' was banned by ' .. GetPlayerName(source)}
    })
end, false)

-- Unban player
RegisterCommand('unban', function(source, args, rawCommand)
    if not HasPermission(source, 'unban') then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local banIndex = tonumber(args[1])
    if not banIndex then
        SendMessage(source, 'Usage: /unban [number] - Use /banlist to see numbers', 'error')
        return
    end

    if bannedPlayers[banIndex] then
        local unbannedName = bannedPlayers[banIndex].name
        table.remove(bannedPlayers, banIndex)
        SaveBans()
        SendMessage(source, 'Unbanned ' .. unbannedName, 'success')
    else
        SendMessage(source, 'Invalid ban number', 'error')
    end
end, false)

-- Ban list
RegisterCommand('banlist', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    if #bannedPlayers == 0 then
        SendMessage(source, 'No players banned', 'info')
        return
    end

    SendMessage(source, '=== BAN LIST (' .. #bannedPlayers .. ') ===', 'info')
    for i, ban in ipairs(bannedPlayers) do
        SendMessage(source, '[' .. i .. '] ' .. ban.name .. ' - ' .. ban.reason .. ' (' .. ban.bannedAt .. ')', 'info')
    end
end, false)

-- Check for banned players on connect
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    deferrals.defer()
    Wait(0)
    deferrals.update('Checking ban status...')

    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        local banned, ban = IsBanned(identifier)
        if banned then
            deferrals.done('You are banned from this server.\nReason: ' .. ban.reason .. '\nBanned by: ' .. ban.bannedBy .. '\nDate: ' .. ban.bannedAt)
            return
        end
    end

    deferrals.done()

    -- Check if admin
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
    if not HasPermission(source, 'gotopl') then
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

-- Give weapon
RegisterCommand('weapon', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1])
    local weapon = args[2]

    if not weapon then
        -- If only one arg, give to self
        weapon = args[1]
        targetId = source
    end

    if not weapon then
        SendMessage(source, 'Usage: /weapon [weapon] or /weapon [id] [weapon]', 'error')
        SendMessage(source, 'Examples: pistol, tec9, ak47, mp5, shotgun', 'info')
        return
    end

    TriggerClientEvent('admin:giveWeapon', targetId, weapon:upper())

    if targetId == source then
        SendMessage(source, 'You gave yourself ' .. weapon, 'success')
    else
        SendMessage(source, 'Gave ' .. weapon .. ' to ' .. GetPlayerName(targetId), 'success')
        SendMessage(targetId, 'You received ' .. weapon .. ' from an admin', 'info')
    end
end, false)

-- Give all weapons
RegisterCommand('allweapons', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    local targetId = tonumber(args[1]) or source
    TriggerClientEvent('admin:giveAllWeapons', targetId)

    if targetId == source then
        SendMessage(source, 'You gave yourself all weapons', 'success')
    else
        SendMessage(source, 'Gave all weapons to ' .. GetPlayerName(targetId), 'success')
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
        local adminMarker = IsAdmin(id) and ' [ADMIN]' or ''
        SendMessage(source, '[' .. id .. '] ' .. GetPlayerName(id) .. adminMarker, 'info')
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

-- Enable nametags
RegisterCommand('nametags', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    TriggerClientEvent('admin:toggleNametags', source)
    SendMessage(source, 'Toggled player nametags', 'success')
end, false)

-- Admin menu
RegisterCommand('admin', function(source, args, rawCommand)
    if not IsAdmin(source) then
        SendMessage(source, 'You do not have permission to use this command', 'error')
        return
    end

    TriggerClientEvent('admin:openMenu', source)
end, false)

print("^2[Admin-System]^7 Loaded " .. #Config.Admins .. " admin(s) from config")
print("^2[Admin-System]^7 Use /makeadmin [id] to add admins in-game")
