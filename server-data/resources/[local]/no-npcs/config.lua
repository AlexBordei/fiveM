Config = {}

-- NPC Settings
Config.DisableNPCs = true              -- Disable random NPC spawning
Config.DisableTraffic = true           -- Disable vehicle traffic
Config.DisableParkedVehicles = true    -- Disable parked vehicles
Config.DisableScenarioPeds = true      -- Disable scenario peds (sitting, smoking, etc.)
Config.DisableBoats = true             -- Disable boat spawning
Config.DisableGarbageTrucks = true     -- Disable garbage trucks
Config.DisableRandomEvents = true      -- Disable random events (cops, ambulance, etc.)

-- Wanted Level Settings
Config.DisableWantedLevel = true       -- Disable police wanted level
Config.DisablePoliceResponse = true    -- Disable police spawning when shooting

-- Ambient Settings
Config.DisableAmbientSirens = true     -- Disable police/ambulance sirens in distance
Config.DisableAmbientHelicopters = true -- Disable ambient helicopters

-- Health Settings
Config.DisableHealthRegeneration = false -- Keep health regeneration enabled by default

-- Distance Settings
Config.PedDensity = 0.0                -- 0.0 = no peds, 1.0 = max peds
Config.VehicleDensity = 0.0            -- 0.0 = no vehicles, 1.0 = max vehicles
Config.ParkedVehicleDensity = 0.0      -- 0.0 = no parked vehicles, 1.0 = max parked

-- Blacklisted Scenarios (will not spawn)
Config.BlacklistedScenarios = {
    'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
    'WORLD_VEHICLE_MILITARY_PLANES_BIG',
    'WORLD_VEHICLE_AMBULANCE',
    'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
    'WORLD_VEHICLE_POLICE_CAR',
    'WORLD_VEHICLE_POLICE_BIKE',
}

-- Suppressed Models (will not spawn)
Config.SuppressedModels = {
    -- Police Vehicles
    `POLICE`,      -- Police Car
    `POLICE2`,     -- Police Car 2
    `POLICE3`,     -- Police Car 3
    `POLICE4`,     -- Police Car 4
    `POLICEB`,     -- Police Bike
    `POLICEOLD1`,  -- Old Police Car
    `POLICEOLD2`,  -- Old Police Car 2
    `POLICET`,     -- Police Transporter
    `RIOT`,        -- Police Riot Van
    `SHERIFF`,     -- Sheriff SUV
    `SHERIFF2`,    -- Sheriff SUV 2
    `PRANGER`,     -- Park Ranger
    `POLMAV`,      -- Police Maverick
    `POLICEB2`,    -- Police Bike 2
    `POLSCHAFTER`, -- Police Schafter
    `FBI`,         -- FBI Car
    `FBI2`,        -- FBI Car 2

    -- Taxis
    `TAXI`,        -- Taxi

    -- Ambulance & Fire
    `AMBULANCE`,   -- Ambulance
    `FIRETRUK`,    -- Fire Truck

    -- Planes
    `SHAMAL`,      -- Plane
    `LUXOR`,       -- Plane
    `LUXOR2`,      -- Plane
    `JET`,         -- Plane
    `LAZER`,       -- Military jet
    `TITAN`,       -- Cargo plane

    -- Military
    `BARRACKS`,    -- Military truck
    `CRUSADER`,    -- Military vehicle
    `RHINO`,       -- Tank

    -- Airport
    `AIRTUG`,      -- Airport vehicle
    `RIPLEY`,      -- Airport vehicle
}
