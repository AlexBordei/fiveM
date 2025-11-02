#!/bin/bash

# FiveM Local Server Runner for macOS
# Uses Docker to run the Linux server locally

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}FiveM Local Server Runner${NC}"
echo -e "${GREEN}====================================${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo -e "${YELLOW}Please install Docker Desktop from: https://www.docker.com/products/docker-desktop${NC}"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker is not running${NC}"
    echo -e "${YELLOW}Please start Docker Desktop and try again${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Checking for existing FiveM container...${NC}"
if docker ps -a | grep -q fivem-local; then
    echo -e "${YELLOW}Removing existing container...${NC}"
    docker rm -f fivem-local 2>/dev/null
fi
echo -e "${GREEN}✓ Ready to start${NC}"
echo ""

echo -e "${YELLOW}Step 2: Starting FiveM server in Docker...${NC}"
docker run -d \
    --name fivem-local \
    -p 30120:30120/tcp \
    -p 30120:30120/udp \
    -v "$(pwd):/server" \
    -w /server \
    --platform linux/amd64 \
    alpine:latest \
    /server/run.sh +exec server.cfg

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Server started${NC}"
    echo ""
    echo -e "${GREEN}====================================${NC}"
    echo -e "${GREEN}Server is running!${NC}"
    echo -e "${GREEN}====================================${NC}"
    echo ""
    echo -e "${YELLOW}Server Information:${NC}"
    echo -e "  Address: ${GREEN}localhost:30120${NC}"
    echo -e "  Container: ${GREEN}fivem-local${NC}"
    echo ""
    echo -e "${YELLOW}Useful Commands:${NC}"
    echo -e "  View logs:        ${GREEN}docker logs -f fivem-local${NC}"
    echo -e "  Stop server:      ${GREEN}docker stop fivem-local${NC}"
    echo -e "  Restart server:   ${GREEN}docker restart fivem-local${NC}"
    echo -e "  Remove container: ${GREEN}docker rm -f fivem-local${NC}"
    echo ""
    echo -e "${YELLOW}Connect to server:${NC}"
    echo -e "  In FiveM, press F8 and type: ${GREEN}connect localhost:30120${NC}"
    echo ""

    # Show live logs
    echo -e "${YELLOW}Showing live logs (Ctrl+C to exit logs):${NC}"
    echo ""
    sleep 2
    docker logs -f fivem-local
else
    echo -e "${RED}✗ Failed to start server${NC}"
    exit 1
fi
