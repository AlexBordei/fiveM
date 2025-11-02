# Legacy Romania Server Management Manual

**Server Name:** Legacy Romania
**Server IP:** 109.123.240.14:30120
**Platform:** Ubuntu 24.04 LTS
**Last Updated:** November 2, 2025

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Local Development](#local-development)
3. [Production Server Management](#production-server-management)
4. [Deployment](#deployment)
5. [Server Commands](#server-commands)
6. [Resource Management](#resource-management)
7. [Monitoring & Logs](#monitoring--logs)
8. [Troubleshooting](#troubleshooting)
9. [Backup & Recovery](#backup--recovery)
10. [Security](#security)

---

## Quick Start

### First Time Setup

1. **Get License Key**
   - Visit https://keymaster.fivem.net
   - Generate a server license key
   - Update `server.cfg`: `sv_licenseKey "YOUR_KEY_HERE"`

2. **Deploy to Production**
   ```bash
   ./deploy.sh
   ```

3. **Access Server**
   - Production: `109.123.240.14:30120`
   - Connect in FiveM: Press F8, type `connect 109.123.240.14:30120`

---

## Local Development

### Running Locally (macOS)

#### Quick Start
```bash
./start-local.sh
```
This interactive script will:
- Check Docker installation
- Start Docker Desktop if needed
- Launch the server
- Show connection info

#### Using Docker Compose
```bash
# Start server
docker-compose up -d

# View logs
docker-compose logs -f

# Stop server
docker-compose down

# Restart server
docker-compose restart
```

#### Using Management Tool
```bash
./fivem.sh
```
Interactive menu for managing both local and production servers.

### Local Server Access
- **Address:** `localhost:30120`
- **Connect:** In FiveM, press F8, type `connect localhost:30120`

---

## Production Server Management

### SSH Access

```bash
# Direct SSH
ssh root@109.123.240.14
# Password: atM76wMuVEkm

# Or use the management tool
./fivem.sh
# Choose option 9: SSH into remote server
```

### Server Control Commands

#### Start Server
```bash
systemctl start fivem
```

#### Stop Server
```bash
systemctl stop fivem
```

#### Restart Server
```bash
systemctl restart fivem
```

#### Check Server Status
```bash
systemctl status fivem
```

#### Enable Auto-Start (Already enabled)
```bash
systemctl enable fivem
```

#### Disable Auto-Start
```bash
systemctl disable fivem
```

### Server Console Access

The server runs in a `screen` session for console access:

```bash
# Attach to server console
screen -r fivem

# Detach from console (without stopping server)
# Press: Ctrl+A, then D

# List screen sessions
screen -ls
```

**WARNING:** Never close the screen session with Ctrl+C as this will stop the server!

---

## Deployment

### Deploy Changes from Local to Production

```bash
./deploy.sh
```

This script:
1. Tests connection to server
2. Creates backup of current server
3. Uploads all files (excluding cache)
4. Sets proper permissions
5. Configures systemd service

### What Gets Deployed

- Server configuration (`server.cfg`)
- All resources in `server-data/resources/`
- Server binaries (alpine/)
- Scripts and management tools
- Documentation

### What Doesn't Get Deployed

- Cache files (`cache/*`)
- Git files (`.git/*`)
- Local Docker files
- Claude context files (`.claude/*`)

### Deploy Specific Resources Only

```bash
# SSH into server
ssh root@109.123.240.14

# Upload specific resource
scp -r /path/to/resource root@109.123.240.14:/home/fivem/server-data/resources/[local]/

# Set permissions
chown -R fivem:fivem /home/fivem/server-data/resources/

# Restart resource (in server console)
screen -r fivem
# Then type: restart resource-name
# Detach: Ctrl+A, D
```

---

## Server Commands

### In-Game Console Commands

Press F8 in-game to open console, then use these commands:

#### Connection
```
connect 109.123.240.14:30120
connect localhost:30120  (for local server)
disconnect
quit
```

#### Server Info
```
status              # Show server status and players
clientkick [id]     # Kick player
```

### Server Console Commands

Access via `screen -r fivem` on the production server:

#### Resource Management
```
refresh                    # Refresh resource list
start [resource]           # Start a resource
stop [resource]            # Stop a resource
restart [resource]         # Restart a resource
ensure [resource]          # Start if not running
```

#### Server Management
```
status                     # Show server status
quit                       # Stop server (use systemctl instead!)
```

#### Player Management
```
clientkick [id] [reason]          # Kick player
tempbanclient [id] [reason]       # Temporary ban
```

#### Permissions
```
add_ace [principal] [ace] [allow/deny]
add_principal [child] [parent]
```

#### Examples
```
# Restart a resource
restart my-resource

# Check what's running
status

# Give admin permissions
add_ace identifier.steam:110000XXXXXXXX command allow
```

---

## Resource Management

### Creating a New Resource

1. **Create Resource Folder**
   ```bash
   mkdir -p server-data/resources/[local]/my-new-resource
   ```

2. **Create fxmanifest.lua**
   ```lua
   fx_version 'cerulean'
   game 'gta5'

   author 'Your Name'
   description 'My New Resource'
   version '1.0.0'

   client_scripts {
       'client.lua'
   }

   server_scripts {
       'server.lua'
   }
   ```

3. **Create Scripts**
   - `client.lua` - Client-side code
   - `server.lua` - Server-side code

4. **Add to server.cfg**
   ```cfg
   ensure my-new-resource
   ```

5. **Deploy and Test**
   ```bash
   # Deploy to production
   ./deploy.sh

   # SSH into server
   ssh root@109.123.240.14

   # Restart the resource
   screen -r fivem
   # Type: restart my-new-resource
   ```

### Resource Locations

- **Core Resources:** `server-data/resources/[system]/`
- **Gameplay Resources:** `server-data/resources/[gameplay]/`
- **Custom Resources:** `server-data/resources/[local]/`
- **Maps:** `server-data/resources/[gamemodes]/[maps]/`

### Current Resources

**System Resources:**
- baseevents - Death and vehicle events
- hardcap - Player limit enforcement
- rconlog - RCON logging
- sessionmanager - Player sessions
- webpack/yarn - Build tools

**Manager Resources:**
- mapmanager - Map management
- spawnmanager - Spawn management

**Gameplay Resources:**
- chat - In-game chat
- playernames - Player name display

**Custom Resources:**
- **character-creator** - Character creation system with name input and spawn selection
  - NUI-based interface with 3-step process (name, appearance, spawn location)
  - Real-time character preview
  - Multiple ped models and heritage presets
  - 5 spawn locations to choose from
  - See `server-data/resources/[local]/character-creator/README.md` for details

- **no-npcs** - Disable NPCs, traffic, and ambient entities
  - Configurable NPC/traffic density (0.0 = none, 1.0 = max)
  - Disable wanted level and police response
  - Clear area on spawn
  - Commands: `/clearnpcs`, `/togglenpcs`
  - See `server-data/resources/[local]/no-npcs/README.md` for configuration options

---

## Monitoring & Logs

### View Live Logs

#### Production Server
```bash
# Via SSH
ssh root@109.123.240.14
tail -f /var/log/fivem.log

# View error logs
tail -f /var/log/fivem_error.log

# Or use management tool
./fivem.sh
# Choose option 7: View remote logs
```

#### Local Server
```bash
# Docker logs
docker-compose logs -f

# Or use management tool
./fivem.sh
# Choose option 3: View local logs
```

### Log Files Location

**Production:**
- Main Log: `/var/log/fivem.log`
- Error Log: `/var/log/fivem_error.log`

**Local:**
- Docker logs (use `docker-compose logs`)

### Check Server Performance

```bash
# SSH into server
ssh root@109.123.240.14

# System resource usage
htop

# Memory usage
free -h

# Disk usage
df -h

# Network connections
ss -tulpn | grep 30120
```

### Service Status

```bash
# Full status
systemctl status fivem -l

# Is server running?
systemctl is-active fivem

# Is auto-start enabled?
systemctl is-enabled fivem
```

---

## Troubleshooting

### Server Won't Start

1. **Check Status**
   ```bash
   systemctl status fivem -l
   ```

2. **Check Logs**
   ```bash
   tail -100 /var/log/fivem.log
   tail -50 /var/log/fivem_error.log
   ```

3. **Common Issues**
   - **Invalid license key:** Update `sv_licenseKey` in server.cfg
   - **Port in use:** Check with `ss -tulpn | grep 30120`
   - **Missing resources:** Ensure all resources in server.cfg exist
   - **Permission issues:** Run `chown -R fivem:fivem /home/fivem`

### Can't Connect to Server

1. **Verify Server is Running**
   ```bash
   systemctl status fivem
   ss -tulpn | grep 30120
   ```

2. **Check Firewall**
   ```bash
   ufw status
   # Should show:
   # 30120/tcp   ALLOW
   # 30120/udp   ALLOW
   ```

3. **Test Connectivity**
   ```bash
   # From your local machine
   nc -zv 109.123.240.14 30120
   ```

### Resource Not Loading

1. **Check Resource Exists**
   ```bash
   ls -la /home/fivem/server-data/resources/[local]/resource-name/
   ```

2. **Check fxmanifest.lua**
   ```bash
   cat /home/fivem/server-data/resources/[local]/resource-name/fxmanifest.lua
   ```

3. **Check Server Console**
   ```bash
   screen -r fivem
   # Look for error messages
   # Try: restart resource-name
   ```

4. **Check Permissions**
   ```bash
   chown -R fivem:fivem /home/fivem/server-data/resources/
   ```

### High Memory Usage

1. **Check What's Using Memory**
   ```bash
   htop
   # Look for FXServer process
   ```

2. **Restart Server**
   ```bash
   systemctl restart fivem
   ```

3. **Reduce Resource Load**
   - Disable unused resources in server.cfg
   - Check for memory leaks in custom scripts

### Server Crashes

1. **Check Crash Logs**
   ```bash
   tail -100 /var/log/fivem_error.log
   journalctl -u fivem -n 100
   ```

2. **Auto-Restart is Configured**
   - Server will automatically restart after crashes
   - Check systemd configuration: `cat /etc/systemd/system/fivem.service`

3. **Common Causes**
   - Buggy resources
   - Memory exhaustion
   - Invalid configuration

---

## Backup & Recovery

### Manual Backup

```bash
# SSH into server
ssh root@109.123.240.14

# Create backup
cd /home
tar -czf fivem_backup_$(date +%Y%m%d_%H%M%S).tar.gz fivem/

# Download backup to local machine
# From your local machine:
scp root@109.123.240.14:/home/fivem_backup_*.tar.gz ~/Desktop/
```

### Automatic Backups

The deployment script automatically creates backups before deploying:
```bash
# Backups are saved as:
/home/fivem_backup_YYYYMMDD_HHMMSS/
```

### Restore from Backup

```bash
# SSH into server
ssh root@109.123.240.14

# Stop server
systemctl stop fivem

# Restore backup
cd /home
rm -rf fivem/
tar -xzf fivem_backup_YYYYMMDD_HHMMSS.tar.gz

# Set permissions
chown -R fivem:fivem fivem/

# Start server
systemctl start fivem
```

### What to Backup

**Essential:**
- `server.cfg` - Server configuration
- `server-data/resources/[local]/` - Custom resources
- `/var/log/fivem.log` - Server logs (optional)

**Not Necessary:**
- `cache/` - Can be regenerated
- `alpine/` - Server binaries (redownloadable)

---

## Security

### Current Security Measures

1. **Firewall (UFW)**
   - Only ports 22 (SSH) and 30120 (FiveM) are open
   - All other ports blocked

2. **Dedicated User**
   - Server runs as `fivem` user (not root)
   - Limited permissions

3. **Service Isolation**
   - Server runs in screen session
   - Managed by systemd

### Best Practices

1. **Change Default Passwords**
   ```bash
   # SSH into server and change root password
   passwd
   ```

2. **Update License Key**
   - Never share your license key
   - Keep it private in server.cfg

3. **Regular Updates**
   ```bash
   # Update system packages
   apt update && apt upgrade -y
   ```

4. **Monitor Logs**
   - Check for suspicious activity
   - Review player connections

5. **Backup Regularly**
   - Create backups before major changes
   - Store backups securely off-server

### Admin Permissions

Add admin permissions in `server.cfg`:

```cfg
# Give specific player admin access
add_ace identifier.steam:110000XXXXXXXX command allow
add_ace identifier.steam:110000XXXXXXXX command.quit deny

# Create admin group
add_ace group.admin command allow
add_principal identifier.steam:110000XXXXXXXX group.admin
```

---

## Quick Reference Commands

### Local Development
```bash
./start-local.sh              # Start local server (interactive)
docker-compose up -d          # Start local server (background)
docker-compose logs -f        # View local logs
docker-compose down           # Stop local server
./fivem.sh                    # Management tool (all options)
```

### Production Management
```bash
./deploy.sh                   # Deploy changes to production
ssh root@109.123.240.14       # SSH into server
systemctl status fivem        # Check server status
systemctl restart fivem       # Restart server
tail -f /var/log/fivem.log    # View live logs
screen -r fivem               # Access server console
```

### Server Console (in screen)
```
refresh                       # Refresh resources
restart resource-name         # Restart specific resource
status                        # Show server status
Ctrl+A, D                     # Detach (don't close!)
```

### Files to Edit
```
server.cfg                    # Server configuration
server-data/resources/[local]/  # Your custom resources
.claudeignore                 # Files to exclude from context
```

---

## Support & Resources

### Official Resources
- **FiveM Docs:** https://docs.fivem.net/docs/
- **Keymaster:** https://keymaster.fivem.net/
- **Forums:** https://forum.cfx.re/
- **Discord:** https://discord.gg/fivem

### Server Information
- **Production IP:** 109.123.240.14
- **Port:** 30120
- **Server Name:** Legacy Romania
- **Platform:** Ubuntu 24.04 LTS
- **FiveM Build:** 17000 (Latest Recommended)

### Claude AI Context
All FiveM documentation is available in `.claude/` directory:
- baseevents, chat, mapmanager, spawnmanager, txAdmin references
- Scripting patterns and examples
- Server management guides

Ask Claude for help with:
- Creating resources
- Debugging issues
- Configuration help
- Scripting assistance

---

## Change Log

### November 2, 2025
- Initial server setup
- Deployed to 109.123.240.14
- Configured auto-start
- Added comprehensive documentation
- Created management tools (fivem.sh, start-local.sh, deploy.sh)
- Set up Claude AI context with FiveM docs

---

**END OF MANUAL**

For additional help, consult the README.md or ask Claude AI for assistance with specific tasks.
