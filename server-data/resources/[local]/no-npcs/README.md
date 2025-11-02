# No NPCs Resource

Permanently removes all NPCs, traffic, police, and ambient entities from the FiveM server.

## Features

This resource automatically and permanently disables:

- **NPCs & Pedestrians**: No random pedestrians spawning
- **Vehicle Traffic**: No civilian vehicles on roads
- **Parked Vehicles**: No parked cars on streets
- **Police**: No police vehicles, helicopters, or wanted levels
- **Emergency Services**: No ambulances or fire trucks
- **Ambient Entities**: No boats, garbage trucks, or ambient helicopters
- **Random Events**: No random police chases or emergency events
- **Scenario Peds**: No NPCs sitting, smoking, or performing activities

## Suppressed Vehicles

The following vehicle models are actively removed if they spawn:

### Police Vehicles
- All police cars (POLICE, POLICE2, POLICE3, POLICE4)
- Police bikes (POLICEB, POLICEB2)
- Sheriff vehicles (SHERIFF, SHERIFF2)
- FBI vehicles (FBI, FBI2)
- SWAT/Riot vans (RIOT)
- Police helicopters (POLMAV)
- Park Rangers (PRANGER)

### Emergency Services
- Taxis (TAXI)
- Ambulances (AMBULANCE)
- Fire trucks (FIRETRUK)

### Aircraft & Military
- Planes (SHAMAL, LUXOR, LUXOR2, JET, TITAN)
- Military jets (LAZER)
- Military vehicles (BARRACKS, CRUSADER, RHINO)
- Airport vehicles (AIRTUG, RIPLEY)

## Installation

Already installed and configured in your server. No additional setup required.

## Configuration

All settings are permanently enabled in `config.lua`. There are **no commands** or toggles available - the server runs without NPCs by default.

This is intentional and cannot be changed during gameplay.

## Technical Details

- Runs continuously on every frame for maximum effectiveness
- Active cleanup every 2 seconds removes any entities that slip through
- Clears area around players on spawn (1000m radius)
- Uses native FiveM functions for optimal performance

## Performance

This resource runs on every frame but uses minimal CPU due to efficient native calls. The active cleanup thread runs every 2 seconds to catch any spawned entities.

## Compatibility

**Compatible with:**
- All FiveM servers
- Character creation systems
- Spawn managers
- Custom spawning scripts

**Not compatible with:**
- Resources that require NPCs/traffic
- Traffic simulation scripts
- Ambient population scripts

## Notes

- NPCs and traffic are disabled **per-client**
- Each player must have the resource running
- This is a permanent setup with no toggle commands
- The server will always run without NPCs and traffic
- Some GTA V mission-specific entities may still spawn briefly but will be cleaned up

## Version

**Version:** 1.0.0
**Last Updated:** November 2, 2025
**Compatibility:** FiveM (all builds)
