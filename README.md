# FiveM Server Setup - Legacy Romania

This directory contains your FiveM server files ready for local editing and remote deployment.

## Quick Start

### Run Locally (macOS)
```bash
./start-local.sh
```
See [LOCAL_SETUP.md](LOCAL_SETUP.md) for detailed local setup instructions.

### Deploy to Production Server
```bash
./deploy.sh
```

## Directory Structure

```
FiveM/
├── alpine/              # FiveM server binaries
├── cache/              # Server cache directory
├── server-data/        # Server data and resources
│   └── resources/
│       └── [local]/
│           └── my-resource/  # Example custom resource
├── server.cfg          # Main server configuration
├── run.sh             # Server start script
└── deploy.sh          # Deployment script for Ubuntu server
```

## Before Deployment

### 1. Get a FiveM License Key

1. Go to https://keymaster.fivem.net
2. Log in with your FiveM account
3. Generate a new server license key
4. Copy the key

### 2. Edit server.cfg

Edit the `server.cfg` file and update:

```cfg
sv_licenseKey "YOUR_LICENSE_KEY_HERE"
sv_hostname "Your Server Name"
sv_maxclients 32  # Adjust as needed
```

### 3. Customize Your Server

- Add custom resources to `server-data/resources/[local]/`
- Edit the example resource in `server-data/resources/[local]/my-resource/`
- Add more resources by creating new folders with `fxmanifest.lua`, `server.lua`, and `client.lua`

## Deployment

### Deploy to Ubuntu Server

Run the deployment script:

```bash
./deploy.sh
```

The script will:
1. Test connection to the server
2. Install required dependencies
3. Upload all server files
4. Configure systemd service
5. Set up firewall rules

### Server Information

- **IP:** 109.123.240.14
- **Port:** 30120
- **User:** root
- **Remote Directory:** /home/fivem

## Managing the Server

### SSH into the Server

```bash
ssh root@109.123.240.14
```

### Start the Server

```bash
systemctl start fivem
```

### Stop the Server

```bash
systemctl stop fivem
```

### Restart the Server

```bash
systemctl restart fivem
```

### Enable Auto-Start on Boot

```bash
systemctl enable fivem
```

### Check Server Status

```bash
systemctl status fivem
```

### View Live Logs

```bash
tail -f /var/log/fivem.log
```

### View Error Logs

```bash
tail -f /var/log/fivem_error.log
```

## Connecting to Your Server

In FiveM client, press F8 and type:

```
connect 109.123.240.14:30120
```

Or add to your favorites using the server IP: `109.123.240.14:30120`

## Adding Resources

1. Create or download resources
2. Place them in `server-data/resources/[local]/`
3. Add `ensure resource-name` to `server.cfg`
4. Run `./deploy.sh` to upload changes
5. Restart the server: `systemctl restart fivem`

## Updating the Server

1. Make changes locally in this directory
2. Run `./deploy.sh` to upload changes
3. SSH into the server and restart: `systemctl restart fivem`

## Troubleshooting

### Server Won't Start

1. Check logs: `tail -f /var/log/fivem.log`
2. Verify license key in `server.cfg`
3. Check firewall: `ufw status`
4. Check service status: `systemctl status fivem`

### Can't Connect

1. Verify firewall allows port 30120: `ufw allow 30120/tcp && ufw allow 30120/udp`
2. Check server is running: `systemctl status fivem`
3. Check server logs for errors

### Port Already in Use

Edit `server.cfg` and change the port:

```cfg
endpoint_add_tcp "0.0.0.0:30121"
endpoint_add_udp "0.0.0.0:30121"
```

Then update firewall rules accordingly.

## Resources

- FiveM Documentation: https://docs.fivem.net
- FiveM Forums: https://forum.cfx.re
- Resource Releases: https://forum.cfx.re/c/development/releases
- Keymaster (License Keys): https://keymaster.fivem.net

## Support

If you need help:
1. Check FiveM documentation
2. Search the forums
3. Ask in the FiveM Discord
