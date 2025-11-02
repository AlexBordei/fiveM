# Legacy Romania - All Commands

Complete list of all available commands for players and admins.

---

## Player Commands

### Basic
| Command | Usage | Description |
|---------|-------|-------------|
| `/help` | `/help` | Show available commands |
| `/players` | `/players` | See online players (requires admin) |

---

## Admin Commands

### Initial Setup

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/setupadmin` | **NONE** | `/setupadmin [password]` | **ONE-TIME USE** - Make yourself Super Admin using master password: `legacy2025admin` |

**Important:** This command only works once when the server is first set up. After first use, it's permanently disabled.

**Example:**
```
/setupadmin legacy2025admin
```

---

### Admin Management

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/makeadmin` | Admin | `/makeadmin [id] [level]` | Give admin to player (1=mod, 2=admin, 3=superadmin) |
| `/removeadmin` | Admin | `/removeadmin [id]` | Remove admin from player |
| `/admin` | Any Admin | `/admin` | Show admin menu with all commands |

**Permission Levels:**
- **1** = Moderator - Basic commands (kick, teleport, vehicles)
- **2** = Admin - Moderator + ban, server control, god mode
- **3** = Super Admin - Full access to everything

**Examples:**
```
/makeadmin 5 1          Make player 5 a moderator
/makeadmin 3 2          Make player 3 an admin
/makeadmin 7 3          Make player 7 a super admin
/removeadmin 5          Remove admin from player 5
```

---

### Player Management

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/kick` | Moderator | `/kick [id] [reason]` | Kick a player from server |
| `/ban` | Admin | `/ban [id] [reason]` | Permanently ban a player |
| `/unban` | Admin | `/unban [number]` | Unban a player (use `/banlist` for numbers) |
| `/banlist` | Admin | `/banlist` | Show all banned players |
| `/freeze` | Moderator | `/freeze [id]` | Freeze/unfreeze a player |
| `/players` | Moderator | `/players` | List all online players with IDs |

**Examples:**
```
/kick 3 Trolling                    Kick player 3 for trolling
/ban 5 Hacking                       Ban player 5 for hacking
/banlist                              Show all bans with numbers
/unban 2                              Unban player #2 from ban list
/freeze 7                             Freeze player 7 in place
```

---

### Teleportation

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/tp` | Moderator | `/tp [x] [y] [z]` | Teleport to coordinates |
| `/goto` | Moderator | `/goto [id]` | Teleport to a player |
| `/bring` | Moderator | `/bring [id]` | Bring a player to you |

**Examples:**
```
/tp -500 200 50          Teleport to coordinates
/goto 5                   Teleport to player 5
/bring 3                  Bring player 3 to you
```

**Popular Locations:**
- Los Santos Airport: `/tp -1037 -2738 20`
- LS City Center: `/tp 215 -880 30`
- Sandy Shores: `/tp 1700 3600 35`
- Paleto Bay: `/tp -150 6400 31`

---

### Vehicle Management

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/car` | Moderator | `/car [model]` | Spawn a vehicle |
| `/dv` | Moderator | `/dv` | Delete current or nearest vehicle |
| `/fix` | Moderator | `/fix` | Repair current vehicle |

**Popular Vehicle Models:**

**Sports Cars:**
- `adder` - Bugatti Veyron style
- `t20` - McLaren P1 style
- `zentorno` - Lamborghini Sesto Elemento
- `elegy2` - Nissan GTR
- `infernus` - Lamborghini Murcielago

**SUVs:**
- `insurgent` - Armored military truck
- `granger` - Suburban SUV
- `baller` - Range Rover style

**Sedans:**
- `sultan` - Subaru Impreza style
- `kuruma` - Mitsubishi Lancer (armored available: `kuruma2`)
- `schafter2` - Mercedes sedan

**Emergency:**
- `police` - Police cruiser
- `police2` - Police Buffalo
- `ambulance` - Ambulance
- `firetruk` - Fire truck

**Motorcycles:**
- `akuma` - Sport bike
- `bati` - Sport bike
- `pcj` - Classic bike

**Examples:**
```
/car adder               Spawn Bugatti Veyron
/car insurgent          Spawn armored truck
/car police             Spawn police car
/dv                      Delete current vehicle
/fix                     Fix current vehicle
```

---

### Player Healing & Buffs

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/heal` | Moderator | `/heal [id]` | Heal a player (no ID = heal yourself) |
| `/armor` | Moderator | `/armor [id]` | Give armor to player (no ID = yourself) |
| `/god` | Admin | `/god` | Toggle god mode (invincibility) for yourself |

**Examples:**
```
/heal                    Heal yourself
/heal 5                  Heal player 5
/armor                   Give yourself armor
/armor 3                 Give armor to player 3
/god                     Toggle god mode on/off
```

---

### Weapons

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/weapon` | Admin | `/weapon [weapon]` | Give yourself a weapon |
| `/weapon` | Admin | `/weapon [id] [weapon]` | Give weapon to a player |
| `/allweapons` | Admin | `/allweapons` | Give yourself all weapons |
| `/allweapons` | Admin | `/allweapons [id]` | Give all weapons to a player |

**Available Weapons:**

**Pistols:**
- `pistol` - Standard pistol
- `combatpistol` - Combat pistol
- `pistol50` - Desert Eagle
- `snspistol` - Compact pistol
- `heavypistol` - Heavy pistol
- `revolver` - Revolver

**SMGs:**
- `microsmg` - Micro SMG (TEC-9 style)
- `smg` - MP5 style
- `assaultsmg` - P90 style
- `minismg` - Mini SMG
- `combatpdw` - Combat PDW

**Shotguns:**
- `pumpshotgun` - Pump shotgun
- `sawnoffshotgun` - Sawed off
- `assaultshotgun` - Auto shotgun
- `heavyshotgun` - Heavy shotgun

**Assault Rifles:**
- `assaultrifle` - AK-47 style
- `carbinerifle` - M4A1 style
- `advancedrifle` - TAR-21 style
- `specialcarbine` - G36C style
- `bullpuprifle` - QBZ-95 style

**Sniper Rifles:**
- `sniperrifle` - Standard sniper
- `heavysniper` - Heavy sniper (.50 cal)
- `marksmanrifle` - Marksman rifle

**Machine Guns:**
- `mg` - Light machine gun
- `combatmg` - Combat MG

**Heavy Weapons:**
- `rpg` - RPG
- `grenadelauncher` - Grenade launcher
- `minigun` - Minigun
- `railgun` - Railgun
- `hominglauncher` - Homing launcher

**Melee:**
- `knife` - Combat knife
- `bat` - Baseball bat
- `crowbar` - Crowbar
- `nightstick` - Police baton
- `hammer` - Hammer
- `golfclub` - Golf club
- `machete` - Machete
- `switchblade` - Switchblade

**Throwables:**
- `grenade` - Frag grenade
- `stickybomb` - Sticky bomb
- `molotov` - Molotov cocktail
- `proxmine` - Proximity mine

**Examples:**
```
/weapon pistol           Give yourself a pistol
/weapon 5 assaultrifle  Give player 5 an AK-47
/weapon microsmg        Give yourself a TEC-9
/allweapons             Give yourself every weapon
/allweapons 3           Give player 3 all weapons
```

---

### Advanced Admin Powers

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/noclip` | Admin | `/noclip` | Toggle noclip mode (fly through walls) |
| `/nametags` | Admin | `/nametags` | Toggle player nametags above heads |

**Noclip Controls:**
- `W` - Move forward
- `S` - Move backward
- `A` - Turn left
- `D` - Turn right
- `Q` - Move down
- `E` - Move up
- `Shift` - Fast speed (5x)
- `Ctrl` - Slow speed (0.2x)

**Examples:**
```
/noclip                  Toggle flying mode on/off
/nametags                Toggle seeing player names/IDs above heads
```

---

### Server Control

| Command | Permission | Usage | Description |
|---------|------------|-------|-------------|
| `/weather` | Admin | `/weather [type]` | Change server weather |
| `/time` | Admin | `/time [hour] [minute]` | Set server time |
| `/announce` | Admin | `/announce [message]` | Send announcement to all players |

**Weather Types:**
- `CLEAR` - Clear sky
- `EXTRASUNNY` - Extra sunny
- `CLOUDS` - Cloudy
- `OVERCAST` - Overcast
- `RAIN` - Raining
- `THUNDER` - Thunderstorm
- `CLEARING` - Clearing up
- `NEUTRAL` - Neutral
- `SNOW` - Snowing
- `BLIZZARD` - Blizzard
- `SNOWLIGHT` - Light snow
- `XMAS` - Christmas snow
- `HALLOWEEN` - Halloween fog

**Time Examples:**
- `0 0` - Midnight
- `6 0` - Sunrise
- `12 0` - Noon
- `18 0` - Sunset
- `19 30` - Evening (6:30 PM)
- `23 0` - Late night

**Examples:**
```
/weather RAIN                        Set weather to rain
/weather CLEAR                       Set weather to clear
/time 12 0                           Set time to noon
/time 0 0                            Set time to midnight
/announce Server restart in 10 mins  Announce to all players
```

---

## Quick Reference

### For New Admins

1. **First time setup:** `/setupadmin legacy2025admin`
2. **See all commands:** `/admin`
3. **See players:** `/players`
4. **Make someone else admin:** `/makeadmin [id] [level]`

### Most Used Commands

```
/players        See who's online
/tp [x] [y] [z] Teleport
/car [model]    Spawn vehicle
/heal           Heal yourself
/god            Toggle invincibility
/noclip         Toggle flying
/kick [id]      Kick player
/ban [id]       Ban player
```

### Emergency Commands

```
/freeze [id]                    Stop griefer immediately
/ban [id] Griefing             Ban griefer
/dv                             Delete problem vehicle
/weather CLEAR                  Reset weather
/announce Emergency restart    Warn players
```

---

## Permission Requirements Summary

**No Permission Required:**
- `/setupadmin` (one-time use)

**Moderator (Level 1):**
- Kick, freeze, teleport, bring, goto
- Heal, armor
- Spawn/delete/fix vehicles
- List players

**Admin (Level 2):**
- Everything Moderator can do, plus:
- Ban, unban, ban list
- God mode, noclip
- Weapons (give/all)
- Nametags
- Weather, time
- Announcements
- Make/remove admins

**Super Admin (Level 3):**
- Full access to all commands
- Server management
- Admin management

---

## Tips

1. **Use `/players` first** to see player IDs before using other commands
2. **God mode** prevents damage but you can still die from falling
3. **Noclip** makes you invisible to other players
4. **Nametags** only show for you, not all admins
5. **Ban list** shows numbers for `/unban` command
6. **Master password** only works once - make other admins with `/makeadmin`
7. **Coordinates** can be found using dev tools or map coordinates
8. **Vehicle models** are lowercase - use exactly as shown
9. **Weapon names** are case-insensitive (pistol = PISTOL)
10. **All admin actions** are logged in server console

---

## Finding Player Information

**Get Player ID:**
```
/players
```

**Get Player Coordinates** (requires dev tools):
- Open F8 console
- Type: `getcoords`

**Common Player Issues:**
- Stuck: `/tp [x] [y] [z]` or `/goto [other-player-id]`
- Griefing: `/freeze [id]` then `/kick [id]` or `/ban [id]`
- Needs help: `/heal [id]` and `/armor [id]`
- Lost vehicle: `/car [model]`

---

## Version

**Version:** 1.0.0
**Last Updated:** November 2, 2025
**Server:** Legacy Romania FiveM

**Master Password:** `legacy2025admin` (one-time use)

For admin documentation, see: `ADMIN_GUIDE.md`
