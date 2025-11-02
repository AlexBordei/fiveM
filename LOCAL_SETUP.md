# Running FiveM Server Locally on macOS

Since FiveM doesn't provide native macOS server builds, there are two ways to run the server locally:

## Option 1: Docker (Recommended)

### Prerequisites
1. Install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)
2. Start Docker Desktop

### Method A: Using Docker Compose

The easiest way to run the server locally:

```bash
docker-compose up
```

To run in background:
```bash
docker-compose up -d
```

View logs:
```bash
docker-compose logs -f
```

Stop server:
```bash
docker-compose down
```

### Method B: Using the run-local.sh Script

Run the provided script:

```bash
./run-local.sh
```

This script will:
- Check if Docker is installed and running
- Start the FiveM server in a Docker container
- Map port 30120 to your local machine
- Show live logs

### Connecting to Local Server

In FiveM client, press **F8** and type:
```
connect localhost:30120
```

Or:
```
connect 127.0.0.1:30120
```

## Option 2: Using a Virtual Machine

If you don't want to use Docker, you can run the server in a Linux VM:

### Using UTM (Recommended for Apple Silicon Macs)

1. Download [UTM](https://mac.getutm.app/)
2. Create an Ubuntu 24.04 VM
3. Install the server in the VM using the deployment script
4. Forward port 30120 from VM to host

### Using VirtualBox (Intel Macs)

1. Download [VirtualBox](https://www.virtualbox.org/)
2. Create an Ubuntu 24.04 VM
3. Install the server in the VM
4. Configure port forwarding for port 30120

## Option 3: Remote Development

The recommended approach for serious development is to:

1. Keep files locally for editing
2. Use the deployment script to push changes to the Ubuntu server
3. Test on the remote server

This is what the current setup is designed for:
- Edit files locally in your IDE
- Run `./deploy.sh` to deploy changes
- Test on `109.123.240.14:30120`

## Troubleshooting

### Docker Issues

**Docker not starting:**
- Make sure Docker Desktop is running
- Check Docker Desktop preferences

**Port already in use:**
- Stop any other service using port 30120
- Change the port in docker-compose.yml

**Container crashes:**
- Check logs: `docker logs fivem-local`
- Ensure server.cfg is valid
- Verify license key is set

### Performance

Running the FiveM server in Docker on macOS may have reduced performance compared to native Linux. For production use, always use a Linux server.

## Recommended Workflow

1. **Development**: Edit files locally on macOS
2. **Testing**: Use Docker for quick local testing
3. **Production**: Deploy to Ubuntu server using `./deploy.sh`

This gives you the best of both worlds - local editing with full IDE support, and production-ready Linux deployment.
