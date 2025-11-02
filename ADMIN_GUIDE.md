# Legacy Romania - FiveM Server Admin Guide

Complete guide for server administrators to manage and maintain the Legacy Romania FiveM server.

---

## Table of Contents

1. [Quick Reference](#quick-reference)
2. [Server Access](#server-access)
3. [Server Management](#server-management)
4. [Resource Management](#resource-management)
5. [Player Management](#player-management)
6. [Monitoring & Logs](#monitoring--logs)
7. [Backups](#backups)
8. [Troubleshooting](#troubleshooting)
9. [Security](#security)

---

## Quick Reference

### Server Information
- **Production Server**: 109.123.240.14:30120
- **Server Name**: Legacy Romania
- **Max Players**: 32
- **License Key**: (stored in server.cfg - not committed to git)

### Key Files
- **Server Config**: `/home/fivem/server.cfg`
- **Player Data**: `/home/fivem/resources/[local]/player-persistence/playerdata.json`
- **Resources**: `/home/fivem/server-data/resources/[local]/`
- **Server Binary**: `/home/fivem/alpine/opt/cfx-server/FXServer`

### Quick Commands
```bash
# SSH into server
ssh root@109.123.240.14
# Password: atM76wMuVEkm

# Attach to server console
screen -r fivem

# Detach from console (don't close!)
Ctrl+A, then D

# Restart server
systemctl restart fivem

# View server logs
journalctl -u fivem -f
```

---

## Server Access

### SSH Access

**Connect to server:**
```bash
ssh root@109.123.240.14
```
- **Username**: root
- **Password**: atM76wMuVEkm

### Server Console Access

The FiveM server runs in a `screen` session for persistent console access.

**Attach to console:**
```bash
screen -r fivem
```

**Detach from console (IMPORTANT - don't close!):**
```
Press: Ctrl+A, then D
```

⚠️ **Never use Ctrl+C** - this will stop the server!

---

## Server Management

### Starting/Stopping the Server

**Start server:**
```bash
systemctl start fivem
```

**Stop server:**
```bash
systemctl stop fivem
```

**Restart server:**
```bash
systemctl restart fivem
```

**Check server status:**
```bash
systemctl status fivem
```

**Enable auto-start on boot:**
```bash
systemctl enable fivem
```

### Server Console Commands

Once attached to the console (`screen -r fivem`), you can use these commands:

**Resource Management:**
```
start <resource>      # Start a resource
stop <resource>       # Stop a resource
restart <resource>    # Restart a resource
refresh               # Scan for new resources
ensure <resource>     # Start resource (auto-restart on failure)
```

**Server Management:**
```
quit                  # Stop the server
status                # Show server status
clientkick <id>       # Kick a player
```

**Player Management:**
```
kickall               # Kick all players
tempban <id> <reason> # Temporarily ban a player
```

---

## Resource Management

### Active Resources

**Default Resources:**
- `mapmanager` - Map management
- `chat` - Chat system
- `spawnmanager` - Player spawning
- `sessionmanager` - Session management
- `basic-gamemode` - Basic game mode
- `hardcap` - Player slot management
- `rconlog` - Remote console logging

**Custom Resources:**
- `loading-screen` - Custom black loading screen with logo
- `player-persistence` - Position and settings persistence
- `no-npcs` - Removes all NPCs and traffic

### Managing Resources

**Restart a resource:**
```bash
# In server console
restart player-persistence
```

**Check resource status:**
```bash
# In server console
ensure player-persistence
```

**Deploy resource updates from local machine:**
```bash
# From your local machine
./deploy.sh
```

### Resource Locations

**Production Server:**
- Default resources: `/home/fivem/server-data/resources/`
- Custom resources: `/home/fivem/server-data/resources/[local]/`

**Local Development:**
- All resources: `./server-data/resources/[local]/`

---

## Player Management

### Player Data Storage

Player data is stored in JSON format at:
```
/home/fivem/resources/[local]/player-persistence/playerdata.json
```

**Data includes:**
- Player position (x, y, z, heading)
- Last saved timestamp
- Player name
- Disconnect time and reason
- Custom settings

### Viewing Player Data

```bash
# On server
cat /home/fivem/resources/[local]/player-persistence/playerdata.json
```

**Example data structure:**
```json
{
  "steam:110000XXXXXXXX": {
    "position": {
      "x": -269.4,
      "y": -955.3,
      "z": 31.2,
      "heading": 206.0
    },
    "lastSaved": "2025-11-02 10:30:45",
    "lastPlayerName": "Alex",
    "lastDisconnect": "2025-11-02 10:35:12",
    "disconnectReason": "Disconnected"
  }
}
```

### Resetting Player Data

**Reset specific player:**
Edit the JSON file and remove their identifier entry.

**Reset all players:**
```bash
# On server
rm /home/fivem/resources/[local]/player-persistence/playerdata.json
# Restart the resource
screen -r fivem
restart player-persistence
```

### Finding Player Identifiers

**In server console:**
```
# Players show their identifiers on connect in the logs
```

**Common identifier types:**
- `steam:` - Steam ID
- `license:` - FiveM license
- `ip:` - IP address

---

## Monitoring & Logs

### Server Logs

**View live logs:**
```bash
journalctl -u fivem -f
```

**View last 100 lines:**
```bash
journalctl -u fivem -n 100
```

**View logs from today:**
```bash
journalctl -u fivem --since today
```

### Console Output

**Attach to live console:**
```bash
screen -r fivem
```

**Capture console output to file:**
```bash
screen -r fivem -X hardcopy /tmp/server-log.txt
cat /tmp/server-log.txt
```

### Resource Logs

Each resource prints logs to the main console:
- `[Player-Persistence]` - Position saving activity
- `[No-NPCs]` - NPC removal activity
- `[resources]` - Resource start/stop events

---

## Backups

### What to Backup

**Essential files:**
1. Player data: `/home/fivem/resources/[local]/player-persistence/playerdata.json`
2. Server config: `/home/fivem/server.cfg` (contains license key!)
3. Custom resources: `/home/fivem/server-data/resources/[local]/`

### Backup Script

**Create backup:**
```bash
#!/bin/bash
BACKUP_DIR="/root/fivem-backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup player data
cp /home/fivem/resources/[local]/player-persistence/playerdata.json $BACKUP_DIR/

# Backup server config
cp /home/fivem/server.cfg $BACKUP_DIR/

# Backup custom resources
cp -r /home/fivem/server-data/resources/[local]/ $BACKUP_DIR/resources/

echo "Backup created at: $BACKUP_DIR"
```

**Save as:**
```bash
nano /root/backup-fivem.sh
chmod +x /root/backup-fivem.sh
```

**Run backup:**
```bash
/root/backup-fivem.sh
```

### Automated Backups

**Create daily backup with cron:**
```bash
crontab -e
```

Add this line:
```
0 3 * * * /root/backup-fivem.sh
```

This runs at 3 AM every day.

### Restore from Backup

```bash
# Stop server
systemctl stop fivem

# Restore player data
cp /root/fivem-backups/YYYYMMDD-HHMMSS/playerdata.json \
   /home/fivem/resources/[local]/player-persistence/

# Restore config
cp /root/fivem-backups/YYYYMMDD-HHMMSS/server.cfg \
   /home/fivem/

# Restore resources
cp -r /root/fivem-backups/YYYYMMDD-HHMMSS/resources/* \
   /home/fivem/server-data/resources/[local]/

# Fix permissions
chown -R fivem:fivem /home/fivem/

# Start server
systemctl start fivem
```

---

## Troubleshooting

### Server Won't Start

**Check status:**
```bash
systemctl status fivem
```

**Check if already running:**
```bash
ps aux | grep FXServer
```

**Kill stuck processes:**
```bash
pkill -f FXServer
systemctl start fivem
```

**Check port availability:**
```bash
netstat -tuln | grep 30120
```

### Players Can't Connect

**Verify server is running:**
```bash
systemctl status fivem
```

**Check firewall:**
```bash
# Port 30120 TCP and UDP must be open
ufw status
```

**Test connectivity:**
```bash
nc -zv 109.123.240.14 30120
```

**Check license key:**
```bash
# Make sure license key is valid in server.cfg
grep sv_licenseKey /home/fivem/server.cfg
```

### Resource Not Loading

**Refresh resources:**
```bash
# In console
refresh
ensure <resource-name>
```

**Check permissions:**
```bash
ls -la /home/fivem/server-data/resources/[local]/
# All should be owned by fivem:fivem
```

**Fix permissions:**
```bash
chown -R fivem:fivem /home/fivem/server-data/resources/[local]/
```

**Check manifest:**
```bash
# Resource must have fxmanifest.lua
cat /home/fivem/server-data/resources/[local]/<resource>/fxmanifest.lua
```

### Player Data Not Saving

**Check file permissions:**
```bash
ls -la /home/fivem/resources/[local]/player-persistence/
```

**Check disk space:**
```bash
df -h
```

**Check resource is running:**
```bash
# In console
ensure player-persistence
```

**View resource logs:**
```bash
# Look for save messages in console
screen -r fivem
```

### Server Crashes

**Check logs:**
```bash
journalctl -u fivem -n 200
```

**Common causes:**
- Out of memory
- Corrupted resource
- Bad configuration

**Quick fix:**
```bash
systemctl restart fivem
```

---

## Security

### License Key Security

⚠️ **NEVER commit server.cfg to GitHub!**

The license key is in `.gitignore` to prevent exposure.

**If key is exposed:**
1. Get new key from https://keymaster.fivem.net
2. Update `server.cfg` on server
3. Restart server
4. Revoke old key

### SSH Access

**Change root password:**
```bash
passwd
```

**Create limited user account:**
```bash
adduser fivemadmin
usermod -aG sudo fivemadmin
```

**Disable root SSH login (optional):**
```bash
nano /etc/ssh/sshd_config
# Set: PermitRootLogin no
systemctl restart sshd
```

### Server Protection

**Rate limiting is configured** in server.cfg:
```
sv_endpointprivacy true
```

**Admin permissions:**
```bash
# In server.cfg
add_principal identifier.steam:YOUR_STEAM_ID group.admin
```

### Firewall

**Ubuntu UFW (if enabled):**
```bash
ufw allow 30120/tcp
ufw allow 30120/udp
ufw allow 22/tcp
ufw enable
```

---

## Development Workflow

### Local Development

**Start local server:**
```bash
./start-local.sh
```

**Management tool:**
```bash
./fivem.sh
```

### Deploying Changes

**From local machine:**
```bash
./deploy.sh
```

This will:
1. Create backup on server
2. Upload changed files
3. Set correct permissions
4. Restart affected resources

### Git Workflow

**Commit changes:**
```bash
git add .
git commit -m "Description of changes"
git push origin master
```

**Pull latest:**
```bash
git pull origin master
```

---

## Common Administrative Tasks

### Adding a New Resource

1. **Create resource locally:**
   ```bash
   mkdir server-data/resources/[local]/my-resource
   cd server-data/resources/[local]/my-resource
   # Create fxmanifest.lua, client.lua, server.lua
   ```

2. **Test locally:**
   ```bash
   ./start-local.sh
   ```

3. **Deploy to production:**
   ```bash
   ./deploy.sh
   ```

4. **Add to server.cfg:**
   ```bash
   ssh root@109.123.240.14
   nano /home/fivem/server.cfg
   # Add: ensure my-resource
   ```

5. **Restart or refresh:**
   ```bash
   screen -r fivem
   refresh
   ensure my-resource
   ```

### Changing Server Name

```bash
# Edit server.cfg
nano /home/fivem/server.cfg

# Change:
sv_hostname "New Server Name"

# Restart server
systemctl restart fivem
```

### Updating Max Players

```bash
# Edit server.cfg
nano /home/fivem/server.cfg

# Change:
sv_maxclients 64

# Restart server
systemctl restart fivem
```

### Viewing Connected Players

```bash
# In console
screen -r fivem
# Look for connection messages
```

---

## Support & Resources

### Documentation
- FiveM Docs: https://docs.fivem.net
- Server Artifacts: https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/
- Native Reference: https://docs.fivem.net/natives/

### File Locations Quick Reference

| Item | Location |
|------|----------|
| Server executable | `/home/fivem/alpine/opt/cfx-server/FXServer` |
| Server config | `/home/fivem/server.cfg` |
| Resources | `/home/fivem/server-data/resources/` |
| Custom resources | `/home/fivem/server-data/resources/[local]/` |
| Player data | `/home/fivem/resources/[local]/player-persistence/playerdata.json` |
| Server logs | `journalctl -u fivem` |
| Screen session | `screen -r fivem` |

### Management Scripts

| Script | Purpose |
|--------|---------|
| `./deploy.sh` | Deploy changes to production |
| `./start-local.sh` | Start local development server |
| `./fivem.sh` | Interactive management tool |
| `./check-server.sh` | Check server status |

---

## Emergency Procedures

### Server is Down

1. **Check if process is running:**
   ```bash
   systemctl status fivem
   ps aux | grep FXServer
   ```

2. **Try starting:**
   ```bash
   systemctl start fivem
   ```

3. **If fails, check logs:**
   ```bash
   journalctl -u fivem -n 100
   ```

4. **Kill stuck processes:**
   ```bash
   pkill -f FXServer
   systemctl start fivem
   ```

5. **Last resort - restart server:**
   ```bash
   reboot
   ```

### Players Reporting Issues

**"I can't connect":**
- Check server is online: `systemctl status fivem`
- Check ports are open: `nc -zv 109.123.240.14 30120`
- Check server isn't full: View console for player count

**"My position wasn't saved":**
- Check player-persistence is running: `screen -r fivem` → `ensure player-persistence`
- Check data file exists: `ls -la /home/fivem/resources/[local]/player-persistence/playerdata.json`

**"I'm stuck on loading screen":**
- This is usually client-side cache issue
- Tell player to clear FiveM cache: `%localappdata%\FiveM\FiveM Application Data\cache`

---

## Maintenance Schedule

**Daily:**
- Check server is running
- Monitor player count
- Review console for errors

**Weekly:**
- Backup player data
- Review logs for issues
- Update resources if needed

**Monthly:**
- Full backup of all server files
- Review and clean up old backups
- Check for FiveM server updates

---

## Contact & Emergency

**Server Host:** Contabo VPS
**IP Address:** 109.123.240.14
**SSH Access:** root@109.123.240.14 (password: atM76wMuVEkm)

**GitHub Repository:** https://github.com/AlexBordei/fiveM

---

*Last Updated: November 2, 2025*
*Server Version: FiveM Build 17000*
