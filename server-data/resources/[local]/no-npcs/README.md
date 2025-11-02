# No-NPCs Resource

Disables NPCs, traffic, and ambient entities in FiveM for a clean, empty world.

## Features

- **Disable NPCs** - Remove all pedestrian spawns
- **Disable Traffic** - Remove all vehicle traffic
- **Disable Parked Vehicles** - Remove vehicles parked on streets
- **Disable Wanted Level** - Prevent police wanted stars
- **Disable Police Response** - Stop police from spawning
- **Disable Ambient Sirens** - Remove distant siren sounds
- **Disable Boats** - Remove random boats
- **Disable Garbage Trucks** - Remove garbage truck spawns
- **Disable Random Events** - Remove dispatch services
- **Disable Scenario Peds** - Remove ambient scenario NPCs
- **Disable Ambient Helicopters** - Remove ambient police/news helicopters
- **Disable Health Regeneration** - Stop automatic health regen
- **Blacklist Scenarios** - Block specific ambient scenarios
- **Suppress Vehicle Models** - Hide specific vehicle models

## Installation

1. **Resource is already installed** in `server-data/resources/[local]/no-npcs/`

2. **Already added to server.cfg** with `ensure no-npcs`

3. **Restart server** or run in console: `restart no-npcs`

## Configuration

Edit `config.lua` to customize behavior:

```lua
Config = {}

-- Toggle Features
Config.DisableNPCs = true                 -- Disable all NPC pedestrians
Config.DisableTraffic = true              -- Disable all vehicle traffic
Config.DisableParkedVehicles = true       -- Disable parked vehicles
Config.DisableScenarioPeds = true         -- Disable scenario NPCs
Config.DisableWantedLevel = true          -- Disable wanted level
Config.DisablePoliceResponse = true       -- Disable police spawning
Config.DisableAmbientSirens = true        -- Disable distant sirens
Config.DisableHealthRegeneration = true   -- Disable health regen
Config.DisableBoats = true                -- Disable random boats
Config.DisableGarbageTrucks = true        -- Disable garbage trucks
Config.DisableRandomEvents = true         -- Disable dispatch services
Config.DisableAmbientHelicopters = true   -- Disable ambient helicopters

-- Density Multipliers (0.0 = none, 1.0 = max)
Config.PedDensity = 0.0                   -- Pedestrian density
Config.VehicleDensity = 0.0               -- Vehicle density
Config.ParkedVehicleDensity = 0.0         -- Parked vehicle density
```

### Example Configurations

**Completely Empty World:**
```lua
Config.DisableNPCs = true
Config.DisableTraffic = true
Config.PedDensity = 0.0
Config.VehicleDensity = 0.0
```

**Reduced Traffic (Not Empty):**
```lua
Config.DisableNPCs = false
Config.DisableTraffic = false
Config.PedDensity = 0.3  -- 30% of normal NPCs
Config.VehicleDensity = 0.2  -- 20% of normal traffic
```

**Only Disable Police:**
```lua
Config.DisableNPCs = false
Config.DisableTraffic = false
Config.DisableWantedLevel = true
Config.DisablePoliceResponse = true
Config.DisableAmbientSirens = true
```

## Commands

### /clearnpcs
Manually clear all NPCs and vehicles in a 1000m radius around you.

**Usage:**
```
/clearnpcs
```

### /togglenpcs
Toggle NPC and traffic spawning on/off (for testing).

**Usage:**
```
/togglenpcs
```

## Advanced Configuration

### Blacklisted Scenarios

Remove specific ambient scenarios by adding to the array:

```lua
Config.BlacklistedScenarios = {
    'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
    'WORLD_VEHICLE_MILITARY_PLANES_BIG',
    'WORLD_VEHICLE_AMBULANCE',
    'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
    'WORLD_VEHICLE_POLICE_CAR',
    'WORLD_VEHICLE_FIRE_TRUCK'
}
```

### Suppressed Vehicle Models

Hide specific vehicle models from spawning:

```lua
Config.SuppressedModels = {
    GetHashKey('POLMAV'),     -- Police Maverick
    GetHashKey('BUZZARD'),    -- Buzzard
    GetHashKey('ANNIHILATOR') -- Annihilator
}
```

## Events

### playerSpawned
When a player spawns, the area around them is automatically cleared (if NPCs/traffic are disabled).

```lua
AddEventHandler('playerSpawned', function()
    -- Area cleared automatically
    -- Radius: 1000m
end)
```

## Performance

This resource runs in the main game loop (`Wait(0)`), which is necessary for continuously disabling NPC spawns. However, it's very lightweight:

- **CPU Usage:** Minimal (native calls are fast)
- **Memory Usage:** < 1MB
- **Network Usage:** None (client-side only)

## Troubleshooting

**NPCs still spawning:**
- Check if `Config.DisableNPCs = true` in config.lua
- Ensure resource is running: `restart no-npcs`
- Use `/clearnpcs` to manually clear area
- Check F8 console for errors

**Traffic still spawning:**
- Check if `Config.DisableTraffic = true`
- Set `Config.VehicleDensity = 0.0`
- Use `/clearnpcs` command
- Some mission vehicles may still spawn (expected)

**Commands not working:**
- Ensure chat resource is running
- Check F8 console for errors
- Try restarting: `restart no-npcs`

**Performance issues:**
- This resource should improve performance by reducing entities
- If issues occur, check for conflicts with other resources
- Disable unused features in config.lua

## Compatibility

**Compatible with:**
- All FiveM servers
- All gamemodes
- Character creation systems
- Spawn managers
- Custom spawning scripts

**May conflict with:**
- Resources that require NPCs/traffic
- Traffic simulation scripts
- Ambient population scripts

## Notes

- NPCs and traffic are disabled **per-client**
- Each player must have the resource running
- Server-spawned entities are not affected
- Mission-specific NPCs may still spawn (GTA V missions)
- Some scenarios may take a moment to fully disable

## Customization

To allow some traffic but no NPCs:

```lua
Config.DisableNPCs = true
Config.DisableTraffic = false
Config.PedDensity = 0.0
Config.VehicleDensity = 0.5  -- 50% traffic
```

To keep world feeling alive but reduce density:

```lua
Config.DisableNPCs = false
Config.DisableTraffic = false
Config.PedDensity = 0.1
Config.VehicleDensity = 0.2
Config.DisablePoliceResponse = true  -- But no cops
```

## Support

For issues or questions:
1. Check F8 console for errors
2. Review config.lua settings
3. Try `/clearnpcs` and `/togglenpcs` commands
4. Restart the resource

## Version

**Version:** 1.0.0
**Last Updated:** November 2, 2025
**Compatibility:** FiveM (all builds)
