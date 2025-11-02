-- No NPCs Client Script
print("^2[No-NPCs]^7 Resource started")

-- Main thread to disable NPCs and traffic
CreateThread(function()
    while true do
        Wait(0)

        -- Disable NPC spawning
        if Config.DisableNPCs then
            SetPedDensityMultiplierThisFrame(Config.PedDensity)
            SetScenarioPedDensityMultiplierThisFrame(Config.PedDensity, Config.PedDensity)
        end

        -- Disable vehicle traffic
        if Config.DisableTraffic then
            SetVehicleDensityMultiplierThisFrame(Config.VehicleDensity)
            SetRandomVehicleDensityMultiplierThisFrame(Config.VehicleDensity)
        end

        -- Disable parked vehicles
        if Config.DisableParkedVehicles then
            SetParkedVehicleDensityMultiplierThisFrame(Config.ParkedVehicleDensity)
        end

        -- Disable scenario peds
        if Config.DisableScenarioPeds then
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        end

        -- Disable wanted level
        if Config.DisableWantedLevel then
            SetMaxWantedLevel(0)
            if GetPlayerWantedLevel(PlayerId()) ~= 0 then
                SetPlayerWantedLevel(PlayerId(), 0, false)
                SetPlayerWantedLevelNow(PlayerId(), false)
            end
        end

        -- Disable police response
        if Config.DisablePoliceResponse then
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCopsOnScenarios(false)
        end

        -- Disable ambient sirens
        if Config.DisableAmbientSirens then
            DistantCopCarSirens(false)
        end

        -- Disable health regeneration
        if Config.DisableHealthRegeneration then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        end
    end
end)

-- Disable boats
if Config.DisableBoats then
    CreateThread(function()
        while true do
            Wait(0)
            SetRandomBoats(false)
        end
    end)
end

-- Disable garbage trucks
if Config.DisableGarbageTrucks then
    CreateThread(function()
        while true do
            Wait(0)
            SetGarbageTrucks(false)
        end
    end)
end

-- Disable random events
if Config.DisableRandomEvents then
    CreateThread(function()
        while true do
            Wait(0)

            -- Disable dispatch services
            for i = 1, 15 do
                EnableDispatchService(i, false)
            end
        end
    end)
end

-- Remove blacklisted scenarios
CreateThread(function()
    for _, scenario in ipairs(Config.BlacklistedScenarios) do
        SetScenarioTypeEnabled(scenario, false)
    end
end)

-- Suppress models
CreateThread(function()
    for _, model in ipairs(Config.SuppressedModels) do
        SetVehicleModelIsSuppressed(model, true)
    end
end)

-- Disable ambient helicopters
if Config.DisableAmbientHelicopters then
    CreateThread(function()
        while true do
            Wait(10000) -- Check every 10 seconds

            -- Get all vehicles
            for vehicle in EnumerateVehicles() do
                if IsVehicleModel(vehicle, `POLMAV`) or
                   IsVehicleModel(vehicle, `BUZZARD`) or
                   IsVehicleModel(vehicle, `MAVERICK`) then

                    -- Check if it's an NPC vehicle (no player driver)
                    local driver = GetPedInVehicleSeat(vehicle, -1)
                    if driver ~= 0 and not IsPedAPlayer(driver) then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        DeleteVehicle(vehicle)
                        DeleteEntity(vehicle)
                    end
                end
            end
        end
    end)
end

-- Delete any suppressed vehicles that spawn
if Config.DisableTraffic then
    CreateThread(function()
        while true do
            Wait(2000) -- Check every 2 seconds

            -- Get all vehicles
            for vehicle in EnumerateVehicles() do
                -- Check if it's a suppressed model
                for _, modelHash in ipairs(Config.SuppressedModels) do
                    if IsVehicleModel(vehicle, modelHash) then
                        -- Check if it's an NPC vehicle (no player driver)
                        local driver = GetPedInVehicleSeat(vehicle, -1)
                        if driver == 0 or not IsPedAPlayer(driver) then
                            SetEntityAsMissionEntity(vehicle, true, true)
                            DeleteVehicle(vehicle)
                            DeleteEntity(vehicle)
                            break
                        end
                    end
                end
            end
        end
    end)
end

-- Clear area of peds and vehicles on spawn
AddEventHandler('playerSpawned', function()
    Wait(1000) -- Wait for spawn to complete

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    -- Clear area around player
    if Config.DisableNPCs then
        ClearAreaOfPeds(coords.x, coords.y, coords.z, 1000.0, 1)
    end

    if Config.DisableTraffic then
        ClearAreaOfVehicles(coords.x, coords.y, coords.z, 1000.0, false, false, false, false, false)
    end

    print("^2[No-NPCs]^7 Cleared area around player")
end)

-- Utility function to enumerate vehicles
function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        local success

        repeat
            coroutine.yield(vehicle)
            success, vehicle = FindNextVehicle(handle)
        until not success

        EndFindVehicle(handle)
    end)
end

print("^2[No-NPCs]^7 All NPC and traffic spawning permanently disabled")
