# Legacy Romania - Server Commands

Complete command reference for Legacy Romania FiveM server.

---

## Table of Contents

- [Player Commands](#player-commands)
- [Admin Commands](#admin-commands)
  - [Initial Setup](#initial-setup)
  - [Admin Management](#admin-management)
  - [Player Management](#player-management)
  - [Teleportation](#teleportation)
  - [Vehicle Management](#vehicle-management)
  - [Player Healing & Buffs](#player-healing--buffs)
  - [Weapons](#weapons)
  - [Advanced Admin Powers](#advanced-admin-powers)
  - [Server Control](#server-control)
- [Quick Reference](#quick-reference)
- [Permission Levels](#permission-levels)

---

## Player Commands

Currently, most commands require admin permissions. Regular players can enjoy the gameplay without NPC interference.

### Basic Commands

| Command | Description |
|---------|-------------|
| Chat | Press `T` to open chat and communicate with other players |
| Voice (if enabled) | Use voice chat to talk with nearby players |

---

## Admin Commands

### Initial Setup

**First Time Server Setup:**

```
/setupadmin legacy2025admin
```

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/setupadmin` | **NONE** | `/setupadmin [password]` | **ONE-TIME USE** - Make yourself Super Admin using master password |

**Important Notes:**
- This command works **only once** when server is first set up
- Password: `legacy2025admin`
- After first use, it's permanently disabled
- Grants Super Admin (Level 3) permissions
- Once you're admin, use `/makeadmin` to add others

**Example:**
```
/setupadmin legacy2025admin
```

---

### Admin Management

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/makeadmin` | Admin | `/makeadmin [id] [level]` | Give admin permissions to a player |
| `/removeadmin` | Admin | `/removeadmin [id]` | Remove admin permissions from a player |
| `/admin` | Any Admin | `/admin` | Show admin menu with all available commands |
| `/players` | Admin | `/players` | List all online players with IDs and admin status |

**Admin Levels:**
- **1** = Moderator - Basic moderation (kick, teleport, vehicles, heal)
- **2** = Admin - Moderator + ban, server control, god mode, weapons
- **3** = Super Admin - Full server control and admin management

**Examples:**
```
/makeadmin 5 1          Make player ID 5 a Moderator
/makeadmin 3 2          Make player ID 3 an Admin
/makeadmin 7 3          Make player ID 7 a Super Admin
/makeadmin 2            Make player ID 2 a Moderator (default level)
/removeadmin 5          Remove admin from player ID 5
/players                See all online players and their IDs
/admin                  Show admin command menu
```

---

### Player Management

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/kick` | Moderator | `/kick [id] [reason]` | Kick a player from the server |
| `/ban` | Admin | `/ban [id] [reason]` | Permanently ban a player |
| `/unban` | Admin | `/unban [number]` | Remove a ban (use `/banlist` to see numbers) |
| `/banlist` | Admin | `/banlist` | Show all banned players with numbers |
| `/freeze` | Moderator | `/freeze [id]` | Freeze/unfreeze a player in place |

**Examples:**
```
/kick 3 Trolling                    Kick player 3 for trolling
/kick 5 AFK too long                Kick player 5 for being AFK
/ban 7 Hacking                      Permanently ban player 7
/ban 2 Griefing and destroying cars Ban player 2 for griefing
/banlist                            Show all bans with numbers
/unban 1                            Unban player #1 from ban list
/freeze 4                           Freeze player 4 in place
/freeze 4                           Unfreeze player 4 (toggle)
```

---

### Teleportation

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/tp` | Moderator | `/tp [x] [y] [z]` | Teleport yourself to coordinates |
| `/goto` | Moderator | `/goto [id]` | Teleport to a player |
| `/bring` | Moderator | `/bring [id]` | Bring a player to your location |

**Popular Locations (Copy coordinates):**

**Los Santos:**
- City Center: `/tp 215 -880 30`
- Airport: `/tp -1037 -2738 20`
- Beach (Vespucci): `/tp -1398 -956 7`
- Grove Street: `/tp 120 -1925 21`
- Vinewood Sign: `/tp 740 1200 345`

**Other Cities:**
- Sandy Shores Airfield: `/tp 1700 3600 35`
- Paleto Bay: `/tp -150 6400 31`
- Grapeseed: `/tp 2500 4900 45`

**Landmarks:**
- Mount Chiliad Summit: `/tp 450 5570 795`
- Military Base: `/tp -2360 3265 33`
- Prison: `/tp 1680 2605 45`

**Examples:**
```
/tp -500 200 50          Teleport to coordinates X=-500, Y=200, Z=50
/goto 5                  Teleport to player ID 5's location
/bring 3                 Bring player ID 3 to you
```

---

### Vehicle Management

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/car` | Moderator | `/car [model]` | Spawn a vehicle at your location |
| `/dv` | Moderator | `/dv` | Delete current or nearest vehicle |
| `/fix` | Moderator | `/fix` | Repair and clean your current vehicle |

**Vehicle Models by Category:**

**Super Cars (Sports):**
```
/car adder          Bugatti Veyron style - fastest car
/car t20            McLaren P1 style
/car zentorno       Lamborghini Sesto Elemento
/car infernus       Lamborghini Murcielago
/car turismor       Ferrari LaFerrari style
/car osiris         Pagani Huayra style
/car entityxf       Koenigsegg style
```

**Sports Cars:**
```
/car elegy2         Nissan GTR (free, great handling)
/car sultan         Subaru Impreza style
/car kuruma         Mitsubishi Lancer (also has armored version)
/car massacro       Aston Martin style
/car carbonizzare   Ferrari California
/car coquette       Corvette C7
```

**SUVs & Off-Road:**
```
/car insurgent      Armored military truck (bulletproof)
/car dubsta2        Mercedes G-Wagon style
/car granger        Suburban SUV (8 seats)
/car baller         Range Rover style
/car sandking       Monster truck style
/car guardian       Hummer H1 style
```

**Sedans:**
```
/car schafter2      Mercedes E-Class
/car fugitive       Dodge Charger style
/car tailgater      Audi A4 style
/car oracle         BMW 7-series style
```

**Emergency Vehicles:**
```
/car police         Police cruiser
/car police2        Police Buffalo (fast)
/car police3        Police interceptor
/car ambulance      Ambulance
/car firetruk       Fire truck
/car sheriff        Sheriff SUV
```

**Motorcycles:**
```
/car akuma          Sport bike (fast)
/car bati           Sport bike
/car hakuchou       Sport bike (fastest)
/car pcj            Classic bike
/car sanchez        Dirt bike
/car thrust         Sci-fi bike
```

**Helicopters:**
```
/car buzzard        Attack helicopter
/car frogger        News helicopter
/car maverick       Tour helicopter
/car cargobob       Transport helicopter (can lift cars)
```

**Planes:**
```
/car luxor          Private jet
/car shamal         Learjet style
/car vestra         Small private plane
/car lazer          Military jet (fast)
```

**Boats:**
```
/car seashark       Jet ski
/car speeder        Speedboat
/car marquis        Yacht
```

**Utility & Fun:**
```
/car trash          Garbage truck
/car benson         Box truck
/car mule           Moving truck
/car bus            City bus
/car tourbus        Tour bus
/car bmx            BMX bike
```

**Examples:**
```
/car adder               Spawn Bugatti Veyron super car
/car insurgent          Spawn armored military truck
/car elegy2             Spawn free sports car with great handling
/car buzzard            Spawn attack helicopter
/dv                      Delete the vehicle you're in or nearby
/fix                     Repair your current vehicle completely
```

---

### Player Healing & Buffs

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/heal` | Moderator | `/heal [id]` | Restore player's health to full (no ID = yourself) |
| `/armor` | Moderator | `/armor [id]` | Give player full armor (no ID = yourself) |
| `/god` | Admin | `/god` | Toggle god mode (invincibility) for yourself |

**Examples:**
```
/heal                    Heal yourself to full health
/heal 5                  Heal player ID 5 to full health
/armor                   Give yourself full armor
/armor 3                 Give player ID 3 full armor
/god                     Toggle god mode on (invincible)
/god                     Toggle god mode off
```

**God Mode Notes:**
- Makes you invincible to bullets, explosions, melee
- You can still die from falling great heights
- Other players cannot see if you have god mode
- Use responsibly

---

### Weapons

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/weapon` | Admin | `/weapon [weapon]` | Give yourself a weapon with ammo |
| `/weapon` | Admin | `/weapon [id] [weapon]` | Give a player a specific weapon |
| `/allweapons` | Admin | `/allweapons` | Give yourself all weapons (60+) |
| `/allweapons` | Admin | `/allweapons [id]` | Give a player all weapons |

**Weapon Names (Organized by Type):**

**Pistols:**
```
/weapon pistol           Standard 9mm pistol
/weapon combatpistol     Combat pistol (better)
/weapon appistol         AP pistol (full auto)
/weapon pistol50         Desert Eagle (.50 cal)
/weapon snspistol        Small compact pistol
/weapon heavypistol      Heavy pistol (.45 ACP)
/weapon vintagepistol    M1911 style
/weapon revolver         Magnum revolver
/weapon marksmanpistol   Long-range pistol
```

**SMGs (Submachine Guns):**
```
/weapon microsmg         TEC-9 style (very fast fire)
/weapon smg              MP5 style
/weapon assaultsmg       P90 style (50 round mag)
/weapon combatpdw       Combat PDW
/weapon machinepistol    Micro SMG (very fast)
/weapon minismg          Mini SMG (smallest)
```

**Shotguns:**
```
/weapon pumpshotgun      Pump action shotgun
/weapon sawnoffshotgun   Sawed-off shotgun
/weapon assaultshotgun   Auto shotgun (fast fire)
/weapon bullpupshotgun   Bullpup shotgun
/weapon heavyshotgun     Heavy shotgun
/weapon dbshotgun        Double barrel
/weapon autoshotgun      Automatic shotgun
```

**Assault Rifles:**
```
/weapon assaultrifle     AK-47 style (7.62mm)
/weapon carbinerifle     M4A1 style (5.56mm)
/weapon advancedrifle    TAR-21 style
/weapon specialcarbine   G36C style
/weapon bullpuprifle     QBZ-95 style
/weapon compactrifle     AKS-74U style
```

**Sniper Rifles:**
```
/weapon sniperrifle      Standard sniper rifle
/weapon heavysniper      .50 cal sniper (most powerful)
/weapon marksmanrifle    Semi-auto marksman rifle
```

**Light Machine Guns:**
```
/weapon mg               Light machine gun
/weapon combatmg         Combat MG (100 round belt)
/weapon gusenberg        Tommy gun (classic)
```

**Heavy Weapons:**
```
/weapon rpg              RPG-7 rocket launcher
/weapon grenadelauncher  Grenade launcher
/weapon minigun          Minigun (Gatling gun)
/weapon railgun          Railgun (experimental)
/weapon hominglauncher   Homing missile launcher
/weapon compactlauncher  Compact grenade launcher
/weapon firework         Firework launcher (fun)
```

**Melee Weapons:**
```
/weapon knife            Combat knife
/weapon nightstick       Police baton
/weapon hammer           Claw hammer
/weapon bat              Baseball bat
/weapon crowbar          Crowbar
/weapon golfclub         Golf club
/weapon bottle           Broken bottle
/weapon dagger           Antique dagger
/weapon hatchet          Hatchet
/weapon knuckle          Brass knuckles
/weapon machete          Machete
/weapon switchblade      Switchblade
/weapon battleaxe        Battle axe
/weapon poolcue          Pool cue
/weapon wrench           Wrench
/weapon flashlight       Heavy flashlight
```

**Throwables:**
```
/weapon grenade          Frag grenade
/weapon stickybomb       C4/Sticky bomb
/weapon proxmine         Proximity mine
/weapon bzgas            Tear gas
/weapon molotov          Molotov cocktail
/weapon flare            Flare gun
/weapon snowball         Snowball (seasonal fun)
```

**Other:**
```
/weapon fireextinguisher Fire extinguisher
/weapon petrolcan        Jerry can (gasoline)
```

**Examples:**
```
/weapon microsmg         Give yourself TEC-9
/weapon assaultrifle     Give yourself AK-47
/weapon pistol50         Give yourself Desert Eagle
/weapon 5 combatpistol  Give player ID 5 a combat pistol
/allweapons             Give yourself all 60+ weapons
/allweapons 3           Give player ID 3 all weapons
```

**Popular Loadouts:**
```
Street Fighter:
/weapon pistol50
/weapon microsmg
/weapon pumpshotgun

Military:
/weapon carbinerifle
/weapon combatpistol
/weapon combatmg

Heavy Assault:
/weapon assaultrifle
/weapon heavysniper
/weapon rpg
/weapon grenade
```

---

### Advanced Admin Powers

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/noclip` | Admin | `/noclip` | Toggle noclip mode (fly through walls) |
| `/nametags` | Admin | `/nametags` | Toggle player nametags above heads |

**Noclip Mode:**

When enabled, you can fly through walls and objects.

**Controls:**
- `W` - Move forward
- `S` - Move backward
- `A` - Turn left
- `D` - Turn right
- `Q` - Move down
- `E` - Move up
- `Shift` - Fast speed (5x faster)
- `Ctrl` - Slow speed (0.2x slower)

**Noclip Notes:**
- Makes you invisible to other players
- Use for testing, building inspection, or catching cheaters
- Remember to disable before interacting with players
- You remain invincible while in noclip

**Nametags:**
- Shows player name and ID above their head
- Only visible to you (not other admins)
- Works up to 50 meters away
- Format: `[ID] PlayerName`
- Useful for identifying players from distance

**Examples:**
```
/noclip                  Enable flying mode
/noclip                  Disable flying mode
/nametags                Show player names above heads
/nametags                Hide player names
```

---

### Server Control

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/weather` | Admin | `/weather [type]` | Change the server weather for all players |
| `/time` | Admin | `/time [hour] [minute]` | Set the server time for all players |
| `/announce` | Admin | `/announce [message]` | Send announcement to all players |

**Weather Types:**

```
/weather CLEAR           Clear blue sky
/weather EXTRASUNNY      Extra sunny (brightest)
/weather CLOUDS          Cloudy
/weather OVERCAST        Overcast (grey)
/weather RAIN            Raining
/weather THUNDER         Thunderstorm with lightning
/weather CLEARING        Clearing up after rain
/weather NEUTRAL         Neutral weather
/weather SNOW            Snowing
/weather BLIZZARD        Heavy snow blizzard
/weather SNOWLIGHT       Light snow
/weather XMAS            Christmas snow
/weather HALLOWEEN       Halloween fog/atmosphere
```

**Time Examples:**

```
/time 0 0                Midnight
/time 6 0                Sunrise (6:00 AM)
/time 12 0               Noon (12:00 PM)
/time 18 0               Sunset (6:00 PM)
/time 19 30              Evening (7:30 PM)
/time 23 0               Late night (11:00 PM)
```

**Announcement Examples:**

```
/announce Server restart in 10 minutes!
/announce New event starting at the airport!
/announce Admins are online - behave or get banned
/announce Welcome to Legacy Romania!
```

**Server Control Examples:**
```
/weather CLEAR                        Set sunny weather
/weather RAIN                         Set rainy weather
/time 12 0                            Set time to noon
/time 0 0                             Set time to midnight
/announce Server restart in 5 mins   Warn all players
```

---

## Quick Reference

### New Admin First Steps

1. **Get admin powers:**
   ```
   /setupadmin legacy2025admin
   ```

2. **See all commands:**
   ```
   /admin
   ```

3. **See who's online:**
   ```
   /players
   ```

4. **Make someone else admin:**
   ```
   /makeadmin [their-id] 3
   ```

---

### Most Used Commands

```bash
# Essential
/players              See all online players
/admin                Show command menu

# Teleportation
/tp -500 200 50      Teleport to coordinates
/goto 5               Go to player 5
/bring 3              Bring player 3 to you

# Vehicles
/car adder            Spawn super car
/car elegy2           Spawn sports car
/dv                   Delete vehicle
/fix                  Fix vehicle

# Player Help
/heal                 Heal yourself
/heal 5               Heal player 5
/armor                Give yourself armor

# Admin Powers
/god                  Toggle invincibility
/noclip               Toggle flying
/nametags             Toggle player names

# Moderation
/freeze 3             Freeze griefer
/kick 3 Reason        Kick player
/ban 3 Reason         Ban player
```

---

### Emergency Commands

When things go wrong:

```bash
# Stop a griefer immediately
/freeze [id]
/ban [id] Griefing

# Clean up mess
/dv                   Delete problem vehicle
/tp 200 -880 30      Teleport away from chaos

# Reset environment
/weather CLEAR        Reset weather
/time 12 0            Reset time to noon

# Warn players
/announce Emergency situation - stay calm
/announce Server restart in 60 seconds
```

---

## Permission Levels

### No Permission Required
- `/setupadmin` (one-time use only)

### Moderator (Level 1)
**Player Management:**
- Kick players
- Freeze/unfreeze players
- List online players

**Teleportation:**
- Teleport to coordinates
- Teleport to players
- Bring players to you

**Vehicles:**
- Spawn vehicles
- Delete vehicles
- Fix vehicles

**Player Support:**
- Heal players
- Give armor

### Admin (Level 2)
**Everything Moderator can do, plus:**

**Advanced Moderation:**
- Ban players
- Unban players
- View ban list

**Admin Powers:**
- God mode
- Noclip

**Weapons:**
- Give weapons
- Give all weapons

**Server Control:**
- Change weather
- Change time
- Server announcements
- Toggle nametags

**Admin Management:**
- Make other admins
- Remove admins

### Super Admin (Level 3)
**Everything Admin can do, plus:**
- Full server control
- All admin commands
- Highest permission level

---

## Tips & Best Practices

### For Moderators
1. **Always use `/players` first** to see correct player IDs
2. **Take screenshots** before banning (evidence)
3. **Give warnings** before kicking/banning when appropriate
4. **Document bans** - use descriptive reasons
5. **Test in noclip** before teleporting to unknown coords

### For Admins
1. **Don't abuse god mode** - play fair when not moderating
2. **Weather/time changes affect all players** - ask first
3. **Announcements are public** - keep them professional
4. **Ban list grows** - use `/banlist` regularly to review
5. **Master password only works once** - make trusted Super Admins early

### For All Staff
1. **Player IDs change** when they reconnect
2. **Coordinates use format** X Y Z (spaces between)
3. **Vehicle models are lowercase** (adder not ADDER)
4. **Weapon names work both ways** (pistol or PISTOL)
5. **All admin actions are logged** in server console
6. **Be visible and helpful** - admins improve player experience
7. **Consistency matters** - enforce rules equally
8. **Save important coordinates** for quick teleports
9. **Know your hotkeys** to respond quickly
10. **Communicate with other admins** about bans and issues

---

## Finding Information

### Get Player ID
```
/players
```
Shows: `[5] PlayerName [ADMIN]`

### Get Your Coordinates
Open F8 console and type:
```
getcoords
```

### Get Player Identifiers
Check server console when player connects - shows Steam ID and License

---

## Common Player Issues

| Problem | Solution |
|---------|----------|
| Player stuck | `/tp [id]` to safe location or `/goto [id]` then `/bring [id]` |
| Player griefing | `/freeze [id]` immediately, then `/kick` or `/ban` |
| Player needs help | `/heal [id]` and `/armor [id]` |
| Player lost vehicle | `/car [model]` to spawn new one |
| Player in wall | `/bring [id]` to bring them to you |
| Player being chased | `/freeze [attacker-id]` to stop them |

---

## Server Information

**Server IP:** `109.123.240.14:30120`
**Server Name:** Legacy Romania
**Master Password:** `legacy2025admin` (one-time use)
**Max Players:** 32

---

## Version

**Version:** 1.0.0
**Last Updated:** November 2, 2025
**Compatible:** FiveM Build 17000+

---

## Additional Documentation

- **Admin Guide:** See `ADMIN_GUIDE.md` for server management
- **Resource Docs:** See individual resource folders for technical details

---

**For technical support or questions, contact the server owner.**

**Enjoy your admin powers responsibly!** 🎮
