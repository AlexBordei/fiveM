# Character Creator System

A complete character creation and customization system for FiveM with name input, appearance selection, and spawn location choice.

## Features

- **3-Step Character Creation Process**
  - Step 1: Basic Information (First Name, Last Name, Date of Birth)
  - Step 2: Appearance (Model Selection, Heritage/Face Presets)
  - Step 3: Spawn Location Selection

- **Real-time Preview** - See your character as you customize
- **Modern UI** - Beautiful gradient interface with smooth animations
- **Age Validation** - Must be 18+ to create character
- **Multiple Spawn Locations** - 5 default locations across the map
- **9 Character Models** - Including GTA V protagonists and various peds
- **Character Persistence** - Data saved (ready for database integration)

## Installation

1. **Resource is already in your server**
   Located at: `server-data/resources/[local]/character-creator/`

2. **Add to server.cfg**
   ```cfg
   ensure character-creator
   ```

3. **Deploy to production**
   ```bash
   ./deploy.sh
   ```

4. **Restart server**
   ```bash
   systemctl restart fivem
   ```

## Usage

### For Players

1. **First Join** - Character creator automatically opens on first spawn
2. **Fill Basic Info** - Enter name and date of birth
3. **Choose Appearance** - Select model and face preset
4. **Select Spawn** - Choose where to spawn
5. **Create** - Click "Create Character" to finish

### Commands

- `/charcreate` - Open character creator manually (for testing)
- `/charinfo` - View your character information
- `/chardelete` - Delete your character (reconnect to create new one)

## Configuration

### Add More Spawn Locations

Edit `client.lua`:

```lua
local spawnLocations = {
    {name = "Your Location", coords = vector3(x, y, z), heading = 0.0},
    -- Add more locations...
}
```

### Add More Character Models

Edit `client.lua`:

```lua
local pedModels = {
    {name = "Custom Name", model = "ped_model_name"},
    -- Add more models...
}
```

### Customize Heritage Presets

Edit `client.lua`:

```lua
face = {
    {shape = 0, skin = 0},  -- Preset 1
    {shape = 3, skin = 3},  -- Preset 2
    -- Add more presets...
}
```

## Database Integration

The resource is ready for database integration. Uncomment and configure the database code in `server.lua`:

### MySQL Setup

1. **Install mysql-async**
   ```bash
   ensure mysql-async
   ```

2. **Create Table**
   ```sql
   CREATE TABLE `characters` (
       `id` INT AUTO_INCREMENT PRIMARY KEY,
       `identifier` VARCHAR(50) NOT NULL,
       `firstname` VARCHAR(50) NOT NULL,
       `lastname` VARCHAR(50) NOT NULL,
       `dob` DATE NOT NULL,
       `model` VARCHAR(50) NOT NULL,
       `heritage` TEXT,
       `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       UNIQUE KEY `identifier` (`identifier`)
   );
   ```

3. **Uncomment Database Code in server.lua**
   - Find `-- TODO: Save to database` comments
   - Uncomment the MySQL.Async code
   - Configure your database connection

## Exports

### Get Character Data

```lua
-- Get character data for a player
local character = exports['character-creator']:getCharacterData(playerId)

if character then
    print('Player name: ' .. character.firstName .. ' ' .. character.lastName)
end
```

### Update Character Data

```lua
-- Update character data
exports['character-creator']:updateCharacterData(playerId, {
    model = 'new_model',
    heritage = {shape = 5, skin = 5}
})
```

## Customization

### UI Styling

Edit `html/css/style.css` to change:
- Colors
- Fonts
- Layout
- Animations

### Character Preview Camera

Edit `client.lua` - `CreateCharacterCamera()` function to adjust:
- Camera position
- Camera angle
- Zoom level

## Default Spawn Locations

1. **Los Santos Airport** - `-1042.4, -2745.8, 21.4`
2. **Sandy Shores** - `1836.4, 3672.0, 34.3`
3. **Paleto Bay** - `-248.5, 6330.8, 32.4`
4. **City Center** - `-265.0, -957.0, 31.2`
5. **Vinewood Hills** - `119.0, 564.0, 184.0`

## Default Character Models

**Male:**
- Franklin (player_zero)
- Michael (player_one)
- Trevor (player_two)
- Skater (a_m_y_skater_01)
- Hipster (a_m_y_hipster_01)
- Business (a_m_y_business_01)

**Female:**
- Hipster (a_f_y_hipster_01)
- Business (a_f_y_business_01)
- Fitness (a_f_y_fitness_01)

## Integration with Other Resources

### ESX Framework

```lua
-- On character creation
AddEventHandler('character:save', function(data)
    -- Create ESX player
    -- Store in ESX database
end)
```

### QBCore Framework

```lua
-- On character creation
AddEventHandler('character:save', function(data)
    -- Create QBCore player
    -- Store in QBCore database
end)
```

### Custom Framework

```lua
-- Listen to character:save event
AddEventHandler('character:save', function(data)
    local source = source
    -- Your framework logic here
end)
```

## Troubleshooting

**Character creator not showing:**
- Ensure resource is started: `ensure character-creator`
- Check for JavaScript errors in F8 console
- Verify NUI is working

**Can't type in inputs:**
- Make sure NuiFocus is enabled
- Check if other resources are blocking input

**Preview not working:**
- Verify camera creation in client.lua
- Check for model loading issues
- Ensure ped models exist

**Character not saving:**
- Check server console for errors
- Verify character data structure
- Enable database integration if needed

## Advanced Features

### Add Clothing Selection

1. Add clothing options to UI
2. Use native functions:
   ```lua
   SetPedComponentVariation(ped, component, drawable, texture, palette)
   ```

### Add Tattoos

1. Add tattoo selector
2. Use native functions:
   ```lua
   SetPedDecoration(ped, collection, overlay)
   ```

### Add Facial Features

1. Add sliders for detailed customization
2. Use native functions:
   ```lua
   SetPedFaceFeature(ped, index, scale)
   ```

## Support

For issues or questions:
1. Check F8 console for errors
2. Check server console for errors
3. Review this README
4. Ask Claude AI for assistance

## Future Enhancements

Planned features:
- [ ] Detailed facial customization (nose, eyes, etc.)
- [ ] Clothing selection
- [ ] Tattoo system
- [ ] Multiple character slots
- [ ] Character deletion confirmation
- [ ] Admin character management panel

## Credits

Created for Legacy Romania FiveM Server
