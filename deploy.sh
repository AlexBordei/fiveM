#!/bin/bash

# FiveM Server Deployment Script
# This script deploys your FiveM server to a remote Ubuntu server

# Server configuration
SERVER_IP="109.123.240.14"
SERVER_USER="root"
SERVER_PASSWORD="atM76wMuVEkm"
REMOTE_DIR="/home/fivem"
LOCAL_DIR="$(pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}FiveM Server Deployment Script${NC}"
echo -e "${GREEN}====================================${NC}"
echo ""

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}sshpass not found. Installing...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! command -v brew &> /dev/null; then
            echo -e "${RED}Homebrew not found. Please install Homebrew first.${NC}"
            exit 1
        fi
        brew install hudochenkov/sshpass/sshpass
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get update && sudo apt-get install -y sshpass
    fi
fi

echo -e "${YELLOW}Step 1: Testing connection to server...${NC}"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" "echo 'Connection successful'" || {
    echo -e "${RED}Failed to connect to server${NC}"
    exit 1
}
echo -e "${GREEN}✓ Connection successful${NC}"
echo ""

echo -e "${YELLOW}Step 2: Checking if FiveM directory exists on remote server...${NC}"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" "[ -d '$REMOTE_DIR' ]"
if [ $? -eq 0 ]; then
    echo -e "${YELLOW}FiveM directory exists. Backing up...${NC}"
    sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" \
        "cp -r $REMOTE_DIR ${REMOTE_DIR}_backup_\$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✓ Backup created${NC}"
else
    echo -e "${YELLOW}Creating FiveM directory...${NC}"
    sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" \
        "mkdir -p $REMOTE_DIR"
    echo -e "${GREEN}✓ Directory created${NC}"
fi
echo ""

echo -e "${YELLOW}Step 3: Installing dependencies on remote server...${NC}"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" << 'ENDSSH'
# Update system
export DEBIAN_FRONTEND=noninteractive
apt-get update

# Install required packages
apt-get install -y wget tar xz-utils screen git curl

# Create fivem user if it doesn't exist
if ! id "fivem" &>/dev/null; then
    useradd -m -s /bin/bash fivem
    echo "FiveM user created"
else
    echo "FiveM user already exists"
fi
ENDSSH
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

echo -e "${YELLOW}Step 4: Uploading FiveM server files...${NC}"
sshpass -p "$SERVER_PASSWORD" rsync -avz --progress \
    -e "ssh -o StrictHostKeyChecking=no" \
    --exclude='cache/*' \
    --exclude='.git/*' \
    "$LOCAL_DIR/" "$SERVER_USER@$SERVER_IP:$REMOTE_DIR/"
echo -e "${GREEN}✓ Files uploaded${NC}"
echo ""

echo -e "${YELLOW}Step 5: Setting up permissions and service...${NC}"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" << ENDSSH
# Set permissions
chown -R fivem:fivem $REMOTE_DIR
chmod +x $REMOTE_DIR/run.sh
chmod +x $REMOTE_DIR/alpine/opt/cfx-server/FXServer

# Create systemd service
cat > /etc/systemd/system/fivem.service << 'EOF'
[Unit]
Description=FiveM Server
After=network.target

[Service]
Type=simple
User=fivem
WorkingDirectory=$REMOTE_DIR
ExecStart=/bin/bash $REMOTE_DIR/run.sh +exec server.cfg
Restart=on-failure
RestartSec=10
StandardOutput=append:/var/log/fivem.log
StandardError=append:/var/log/fivem_error.log

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Create log files
touch /var/log/fivem.log /var/log/fivem_error.log
chown fivem:fivem /var/log/fivem.log /var/log/fivem_error.log

echo "Service file created"
ENDSSH
echo -e "${GREEN}✓ Permissions and service configured${NC}"
echo ""

echo -e "${YELLOW}Step 6: Configuring firewall...${NC}"
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" << 'ENDSSH'
# Install UFW if not present
if ! command -v ufw &> /dev/null; then
    apt-get install -y ufw
fi

# Configure firewall
ufw allow 22/tcp
ufw allow 30120/tcp
ufw allow 30120/udp
ufw --force enable

echo "Firewall configured"
ENDSSH
echo -e "${GREEN}✓ Firewall configured${NC}"
echo ""

echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}====================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Get a license key from: ${GREEN}https://keymaster.fivem.net${NC}"
echo -e "2. Edit server.cfg and add your license key"
echo -e "3. Start the server with: ${GREEN}systemctl start fivem${NC}"
echo -e "4. Enable auto-start with: ${GREEN}systemctl enable fivem${NC}"
echo -e "5. Check status with: ${GREEN}systemctl status fivem${NC}"
echo -e "6. View logs with: ${GREEN}tail -f /var/log/fivem.log${NC}"
echo ""
echo -e "${YELLOW}To manage the server remotely:${NC}"
echo -e "  ssh $SERVER_USER@$SERVER_IP"
echo ""
echo -e "${YELLOW}Server will be accessible at:${NC}"
echo -e "  ${GREEN}$SERVER_IP:30120${NC}"
echo ""
