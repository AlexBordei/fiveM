# FiveM Server Project Context

## Project Overview
**Server Name:** Legacy Romania
**Type:** FiveM Roleplay Server
**Platform:** Ubuntu 24.04 (Production) + macOS (Development)

## Official Documentation
Primary documentation source: https://docs.fivem.net/docs/

### Key Documentation Sections
- **Server Manual:** https://docs.fivem.net/docs/server-manual/
- **Scripting Reference:** https://docs.fivem.net/docs/scripting-reference/
- **Native Reference:** https://docs.fivem.net/natives/
- **Resources:** https://docs.fivem.net/docs/resources/
- **Server Commands:** https://docs.fivem.net/docs/server-manual/server-commands/

## Server Information

### Production Server
- **IP:** 109.123.240.14
- **Port:** 30120
- **OS:** Ubuntu 24.04 LTS
- **User:** root
- **Location:** /home/fivem
- **Service:** systemd (fivem.service)
- **Logs:** /var/log/fivem.log

### Local Development
- **Platform:** macOS (Docker)
- **Address:** localhost:30120
- **Method:** Docker Compose

## Configuration

### Server Settings
- **License Key:** Set in server.cfg
- **Max Players:** 32
- **OneSync:** Enabled
- **Locale:** ro-RO (Romanian)
- **Tags:** roleplay, romania, romanian, legacy

### Resources Directory Structure
```
server-data/resources/
├── [gamemodes]/        # Game modes and maps
├── [gameplay]/         # Gameplay resources (chat, money, etc.)
├── [local]/           # Custom resources
├── [managers]/        # Manager resources (mapmanager, spawnmanager)
├── [system]/          # System resources (hardcap, rconlog, etc.)
└── [test]/            # Test resources
```

### Default Resources Loaded
- mapmanager
- chat (requires webpack build)
- spawnmanager
- sessionmanager
- basic-gamemode
- hardcap
- rconlog

## Project Structure

### Important Files
- `server.cfg` - Main server configuration
- `run.sh` - Server startup script (Linux)
- `deploy.sh` - Production deployment script
- `start-local.sh` - Local development launcher
- `fivem.sh` - Management tool for both environments
- `docker-compose.yml` - Docker configuration for local dev

### Resources Development
Custom resources should be placed in:
- `server-data/resources/[local]/your-resource/`

Each resource needs:
- `fxmanifest.lua` - Resource manifest
- `server.lua` - Server-side scripts (optional)
- `client.lua` - Client-side scripts (optional)

## Common Tasks

### Deploy Changes to Production
```bash
./deploy.sh
```

### Run Server Locally
```bash
./start-local.sh
# or
docker-compose up -d
```

### Manage Servers
```bash
./fivem.sh  # Interactive menu
```

### Server Management Commands

#### Production (SSH required)
```bash
# Status
systemctl status fivem

# Start/Stop/Restart
systemctl start fivem
systemctl stop fivem
systemctl restart fivem

# View logs
tail -f /var/log/fivem.log

# Access server console
screen -r fivem
```

#### Local (Docker)
```bash
# Start
docker-compose up -d

# Logs
docker-compose logs -f

# Stop
docker-compose down

# Restart
docker-compose restart
```

## FiveM Scripting Basics

### Resource Manifest (fxmanifest.lua)
```lua
fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Resource Description'
version '1.0.0'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}
```

### Server Events
```lua
-- Server-side
RegisterCommand('commandname', function(source, args, rawCommand)
    -- source = player ID
end, false)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    -- Handle player connecting
end)
```

### Client Events
```lua
-- Client-side
RegisterCommand('commandname', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
end, false)
```

## Troubleshooting

### Common Issues

**Resources Not Loading:**
- Check resource path in `server.cfg`
- Ensure resources directory is properly linked
- Verify fxmanifest.lua exists and is valid

**Server Won't Start:**
- Check license key in `server.cfg`
- Review logs: `/var/log/fivem.log` (production) or `docker logs fivem-local` (local)
- Ensure port 30120 is not in use

**Connection Issues:**
- Verify firewall allows port 30120 (TCP & UDP)
- Check server is running: `systemctl status fivem`
- Confirm IP and port are correct

## Development Workflow

1. **Edit Files Locally:** Use your IDE on macOS
2. **Test Locally:** Run with Docker (`./start-local.sh`)
3. **Deploy to Production:** Use deployment script (`./deploy.sh`)
4. **Monitor:** Check logs and server status
5. **Iterate:** Make changes and redeploy

## Security Notes

- License keys are stored in server.cfg
- Server credentials in deploy.sh and fivem.sh
- Firewall configured for ports 22 (SSH) and 30120 (FiveM)
- Server runs as dedicated 'fivem' user on production

## Resources

- **Documentation:** https://docs.fivem.net/docs/
- **Forums:** https://forum.cfx.re/
- **License Keys:** https://keymaster.fivem.net/
- **Resource Releases:** https://forum.cfx.re/c/development/releases
- **Native Reference:** https://docs.fivem.net/natives/

## Environment Variables

None currently set. Add custom environment variables in:
- Production: systemd service file (`/etc/systemd/system/fivem.service`)
- Local: docker-compose.yml

## Notes

- Chat resource requires webpack for building (currently fails gracefully)
- Server uses screen on production for proper console handling
- Resources are symlinked on production: `/home/fivem/resources -> /home/fivem/server-data/resources`
- macOS cannot run FiveM server natively - Docker required
