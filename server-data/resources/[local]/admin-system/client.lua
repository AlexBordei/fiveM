-- Admin System Client Script
print("^2[Admin-System]^7 Client script loaded")

local godMode = false
local frozenPlayers = {}
local noclipEnabled = false

-- Teleport to player
RegisterNetEvent('admin:teleportToPlayer')
AddEventHandler('admin:teleportToPlayer', function(targetId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    local targetCoords = GetEntityCoords(targetPed)

    SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
end)

-- Bring player to you
RegisterNetEvent('admin:bringPlayer')
AddEventHandler('admin:bringPlayer', function(adminId)
    local adminPed = GetPlayerPed(GetPlayerFromServerId(adminId))
    local adminCoords = GetEntityCoords(adminPed)

    SetEntityCoords(PlayerPedId(), adminCoords.x, adminCoords.y, adminCoords.z, false, false, false, false)
end)

-- Freeze player
RegisterNetEvent('admin:freezePlayer')
AddEventHandler('admin:freezePlayer', function()
    local ped = PlayerPedId()
    local frozen = frozenPlayers[ped] or false

    frozenPlayers[ped] = not frozen
    FreezeEntityPosition(ped, not frozen)

    if not frozen then
        TriggerEvent('chat:addMessage', {
            color = {255, 165, 0},
            args = {'[Admin]', 'You have been frozen'}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'[Admin]', 'You have been unfrozen'}
        })
    end
end)

-- Heal player
RegisterNetEvent('admin:healPlayer')
AddEventHandler('admin:healPlayer', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
end)

-- Armor player
RegisterNetEvent('admin:armorPlayer')
AddEventHandler('admin:armorPlayer', function()
    local ped = PlayerPedId()
    SetPedArmour(ped, 100)
end)

-- Teleport to coordinates
RegisterNetEvent('admin:teleportToCoords')
AddEventHandler('admin:teleportToCoords', function(x, y, z)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end)

-- Spawn vehicle
RegisterNetEvent('admin:spawnVehicle')
AddEventHandler('admin:spawnVehicle', function(model)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(10)
    end

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    SetPedIntoVehicle(ped, vehicle, -1)
    SetVehicleEngineOn(vehicle, true, true, false)

    SetModelAsNoLongerNeeded(model)

    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {'[Admin]', 'Vehicle spawned: ' .. model}
    })
end)

-- Delete vehicle
RegisterNetEvent('admin:deleteVehicle')
AddEventHandler('admin:deleteVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle ~= 0 then
        DeleteVehicle(vehicle)
    else
        -- Delete nearest vehicle
        local coords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')

        for _, veh in ipairs(vehicles) do
            local vehCoords = GetEntityCoords(veh)
            local distance = #(coords - vehCoords)

            if distance < 5.0 then
                DeleteVehicle(veh)
                break
            end
        end
    end
end)

-- Fix vehicle
RegisterNetEvent('admin:fixVehicle')
AddEventHandler('admin:fixVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, false)

        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'[Admin]', 'Vehicle fixed'}
        })
    end
end)

-- Set weather
RegisterNetEvent('admin:setWeather')
AddEventHandler('admin:setWeather', function(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
end)

-- Set time
RegisterNetEvent('admin:setTime')
AddEventHandler('admin:setTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)

-- God mode command
RegisterCommand('god', function()
    godMode = not godMode

    if godMode then
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'[Admin]', 'God mode enabled'}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'[Admin]', 'God mode disabled'}
        })
    end
end, false)

-- Noclip command
RegisterCommand('noclip', function()
    noclipEnabled = not noclipEnabled

    local ped = PlayerPedId()

    if noclipEnabled then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)

        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'[Admin]', 'Noclip enabled - WASD to move, Shift=fast, Ctrl=slow'}
        })
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)

        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'[Admin]', 'Noclip disabled'}
        })
    end
end, false)

-- God mode thread
CreateThread(function()
    while true do
        Wait(0)

        if godMode then
            local ped = PlayerPedId()
            SetEntityInvincible(ped, true)
            SetPlayerInvincible(PlayerId(), true)
        end
    end
end)

-- Noclip thread
CreateThread(function()
    while true do
        Wait(0)

        if noclipEnabled then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            FreezeEntityPosition(ped, true)
            SetEntityCollision(ped, false, false)

            local speed = 1.0
            if IsControlPressed(0, 21) then -- Shift
                speed = 5.0
            elseif IsControlPressed(0, 36) then -- Ctrl
                speed = 0.2
            end

            -- Forward/Backward
            if IsControlPressed(0, 32) then -- W
                local forward = GetEntityForwardVector(ped)
                SetEntityCoords(ped, coords.x + forward.x * speed, coords.y + forward.y * speed, coords.z + forward.z * speed, false, false, false, false)
            end

            if IsControlPressed(0, 33) then -- S
                local forward = GetEntityForwardVector(ped)
                SetEntityCoords(ped, coords.x - forward.x * speed, coords.y - forward.y * speed, coords.z - forward.z * speed, false, false, false, false)
            end

            -- Left/Right
            if IsControlPressed(0, 34) then -- A
                SetEntityHeading(ped, heading + 2.0)
            end

            if IsControlPressed(0, 35) then -- D
                SetEntityHeading(ped, heading - 2.0)
            end

            -- Up/Down
            if IsControlPressed(0, 44) then -- Q
                SetEntityCoords(ped, coords.x, coords.y, coords.z - speed, false, false, false, false)
            end

            if IsControlPressed(0, 38) then -- E
                SetEntityCoords(ped, coords.x, coords.y, coords.z + speed, false, false, false, false)
            end
        else
            local ped = PlayerPedId()
            FreezeEntityPosition(ped, false)
            SetEntityCollision(ped, true, true)
        end
    end
end)

-- Simple admin menu
RegisterNetEvent('admin:openMenu')
AddEventHandler('admin:openMenu', function()
    TriggerEvent('chat:addMessage', {
        color = {0, 150, 255},
        multiline = true,
        args = {'[Admin Menu]', 'Available Commands:\n' ..
            '/kick [id] [reason] - Kick player\n' ..
            '/bring [id] - Bring player to you\n' ..
            '/goto [id] - Teleport to player\n' ..
            '/freeze [id] - Freeze/unfreeze player\n' ..
            '/heal [id] - Heal player (or yourself)\n' ..
            '/armor [id] - Give armor\n' ..
            '/tp [x] [y] [z] - Teleport to coords\n' ..
            '/car [model] - Spawn vehicle\n' ..
            '/dv - Delete vehicle\n' ..
            '/fix - Fix vehicle\n' ..
            '/god - Toggle god mode\n' ..
            '/noclip - Toggle noclip\n' ..
            '/weather [type] - Change weather\n' ..
            '/time [hour] [min] - Set time\n' ..
            '/announce [msg] - Server announcement\n' ..
            '/players - List online players'
        }
    })
end)

print("^2[Admin-System]^7 Client ready")
