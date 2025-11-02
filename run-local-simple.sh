#!/bin/bash

# FiveM Local Server Runner for macOS (Simple Version)
# Runs the Linux server directly using the proot environment

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}FiveM Local Server (Simple Mode)${NC}"
echo -e "${GREEN}====================================${NC}"
echo ""

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to script directory
cd "$SCRIPT_DIR" || exit 1

# Check if server files exist
if [ ! -f "run.sh" ]; then
    echo -e "${RED}Error: Server files not found${NC}"
    echo -e "${YELLOW}Make sure you're running this from the FiveM server directory${NC}"
    exit 1
fi

# Check if alpine directory exists
if [ ! -d "alpine" ]; then
    echo -e "${RED}Error: Alpine Linux environment not found${NC}"
    echo -e "${YELLOW}The server files may not be properly installed${NC}"
    exit 1
fi

echo -e "${YELLOW}Note: macOS doesn't have native FiveM server support${NC}"
echo -e "${YELLOW}This will attempt to run the Linux version${NC}"
echo ""

echo -e "${YELLOW}Starting FiveM server...${NC}"
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
echo ""

# Make sure run.sh is executable
chmod +x run.sh

# Try to run the server
# Note: This may not work on macOS as it's a Linux binary
./run.sh +exec server.cfg

# If we get here, the server stopped
echo ""
echo -e "${YELLOW}Server stopped${NC}"
