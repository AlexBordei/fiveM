-- Character Creator Client Script
local isCreatingCharacter = false
local playerData = {}
local cam = nil
local spawnLocations = {
    {name = "Los Santos Airport", coords = vector3(-1042.4, -2745.8, 21.4), heading = 328.5},
    {name = "Sandy Shores", coords = vector3(1836.4, 3672.0, 34.3), heading = 210.5},
    {name = "Paleto Bay", coords = vector3(-248.5, 6330.8, 32.4), heading = 315.2},
    {name = "City Center", coords = vector3(-265.0, -957.0, 31.2), heading = 205.7},
    {name = "Vinewood Hills", coords = vector3(119.0, 564.0, 184.0), heading = 180.0}
}

-- Ped models for selection
local pedModels = {
    {name = "Franklin", model = "player_zero"},
    {name = "Michael", model = "player_one"},
    {name = "Trevor", model = "player_two"},
    {name = "Male 1", model = "a_m_y_skater_01"},
    {name = "Male 2", model = "a_m_y_hipster_01"},
    {name = "Male 3", model = "a_m_y_business_01"},
    {name = "Female 1", model = "a_f_y_hipster_01"},
    {name = "Female 2", model = "a_f_y_business_01"},
    {name = "Female 3", model = "a_f_y_fitness_01"}
}

-- Character presets
local characterPresets = {
    -- Facial features (heritage)
    face = {
        {shape = 0, skin = 0},  -- Default
        {shape = 3, skin = 3},
        {shape = 6, skin = 6},
        {shape = 9, skin = 9}
    }
}

-- Start character creation on spawn
AddEventHandler('playerSpawned', function()
    if not playerData.hasCharacter then
        StartCharacterCreation()
    end
end)

-- Start character creation
function StartCharacterCreation()
    isCreatingCharacter = true

    -- Disable controls during creation
    CreateThread(function()
        while isCreatingCharacter do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- Camera
            EnableControlAction(0, 2, true) -- Camera
        end
    end)

    -- Freeze player
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false)

    -- Create camera
    CreateCharacterCamera()

    -- Open NUI
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "showCharacterCreator",
        spawnLocations = spawnLocations,
        pedModels = pedModels
    })
end

-- Create camera for character preview
function CreateCharacterCamera()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, coords.x + 2.0, coords.y + 2.0, coords.z + 0.5)
    PointCamAtEntity(cam, ped, 0.0, 0.0, 0.0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
end

-- Destroy camera
function DestroyCharacterCamera()
    if cam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
end

-- NUI Callbacks
RegisterNUICallback('previewCharacter', function(data, cb)
    local ped = PlayerPedId()

    -- Change ped model if selected
    if data.model then
        local modelHash = GetHashKey(data.model)
        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(0)
        end

        SetPlayerModel(PlayerId(), modelHash)
        SetModelAsNoLongerNeeded(modelHash)

        ped = PlayerPedId()
        SetPedDefaultComponentVariation(ped)
    end

    -- Apply customization
    if data.heritage then
        SetPedHeadBlendData(ped, data.heritage.shape, data.heritage.shape, 0,
            data.heritage.skin, data.heritage.skin, 0, 0.5, 0.5, 0.0, false)
    end

    -- Update camera to look at new ped
    if cam then
        PointCamAtEntity(cam, ped, 0.0, 0.0, 0.5, true)
    end

    cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
    -- Store character data
    playerData = {
        firstName = data.firstName,
        lastName = data.lastName,
        dateOfBirth = data.dateOfBirth,
        model = data.model,
        heritage = data.heritage,
        spawnLocation = data.spawnLocation,
        hasCharacter = true
    }

    -- Send to server
    TriggerServerEvent('character:save', playerData)

    -- Spawn player
    SpawnPlayer(data.spawnLocation)

    -- Close NUI
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "hideCharacterCreator"
    })

    -- Clean up
    DestroyCharacterCamera()
    isCreatingCharacter = false

    cb('ok')
end)

RegisterNUICallback('closeCreator', function(data, cb)
    SetNuiFocus(false, false)
    DestroyCharacterCamera()
    isCreatingCharacter = false
    cb('ok')
end)

-- Spawn player at selected location
function SpawnPlayer(locationIndex)
    local location = spawnLocations[locationIndex]

    if not location then
        location = spawnLocations[1] -- Default to first location
    end

    -- Unfreeze and make visible
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)

    -- Spawn
    exports.spawnmanager:spawnPlayer({
        x = location.coords.x,
        y = location.coords.y,
        z = location.coords.z,
        heading = location.heading,
        model = playerData.model,
        skipFade = false
    }, function()
        -- Post-spawn setup
        local ped = PlayerPedId()

        -- Apply saved customization
        if playerData.heritage then
            SetPedHeadBlendData(ped, playerData.heritage.shape, playerData.heritage.shape, 0,
                playerData.heritage.skin, playerData.heritage.skin, 0, 0.5, 0.5, 0.0, false)
        end

        -- Set health
        SetEntityHealth(ped, 200)

        -- Notification
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'Character', 'Welcome to Legacy Romania, ' .. playerData.firstName .. ' ' .. playerData.lastName .. '!'}
        })
    end)
end

-- Command to open character creator (for testing)
RegisterCommand('charcreate', function()
    StartCharacterCreation()
end, false)

-- Load character on resource start
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Request character data from server
        TriggerServerEvent('character:requestData')
    end
end)

-- Receive character data from server
RegisterNetEvent('character:receiveData')
AddEventHandler('character:receiveData', function(data)
    if data then
        playerData = data
        playerData.hasCharacter = true
    else
        playerData.hasCharacter = false
    end
end)
