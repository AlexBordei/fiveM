Config = {}

-- Admin identifiers (Steam IDs, FiveM licenses, etc.)
-- Add your admin identifiers here
Config.Admins = {
    -- Example formats:
    -- 'steam:110000XXXXXXXX',
    -- 'license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    -- 'ip:127.0.0.1',

    -- Add your identifier here:
    -- You can find your identifier in the server console when you connect
}

-- Permission levels
Config.Permissions = {
    moderator = 1,
    admin = 2,
    superadmin = 3,
}

-- Assign permission levels to identifiers
Config.AdminLevels = {
    -- Example:
    -- ['steam:110000XXXXXXXX'] = Config.Permissions.superadmin,
}

-- Commands and their required permission levels
Config.CommandPermissions = {
    -- Player Management
    kick = Config.Permissions.moderator,
    ban = Config.Permissions.admin,
    unban = Config.Permissions.admin,
    teleport = Config.Permissions.moderator,
    bring = Config.Permissions.moderator,
    gotopl = Config.Permissions.moderator,
    freeze = Config.Permissions.moderator,

    -- Vehicle Management
    spawnvehicle = Config.Permissions.moderator,
    deletevehicle = Config.Permissions.moderator,
    fixvehicle = Config.Permissions.moderator,

    -- Player Control
    heal = Config.Permissions.moderator,
    armor = Config.Permissions.moderator,
    god = Config.Permissions.admin,
    noclip = Config.Permissions.admin,

    -- Server Management
    announce = Config.Permissions.admin,
    cleararea = Config.Permissions.admin,
    weather = Config.Permissions.admin,
    time = Config.Permissions.admin,
}

-- Vehicle list for spawn menu (popular vehicles)
Config.Vehicles = {
    {name = "Adder", model = "adder"},
    {name = "T20", model = "t20"},
    {name = "Zentorno", model = "zentorno"},
    {name = "Insurgent", model = "insurgent"},
    {name = "Kuruma", model = "kuruma"},
    {name = "Sultan", model = "sultan"},
    {name = "Elegy", model = "elegy2"},
    {name = "Police Car", model = "police"},
    {name = "Ambulance", model = "ambulance"},
    {name = "Fire Truck", model = "firetruk"},
}

-- Weather types
Config.WeatherTypes = {
    "CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST",
    "RAIN", "THUNDER", "CLEARING", "NEUTRAL",
    "SNOW", "BLIZZARD", "SNOWLIGHT", "XMAS", "HALLOWEEN"
}
