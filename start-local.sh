#!/bin/bash

# Quick start script for local FiveM server

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║   FiveM Server - Local Launcher      ║"
echo "  ║          Legacy Romania              ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed${NC}"
    echo ""
    echo -e "${YELLOW}To run FiveM server locally on macOS, you need Docker.${NC}"
    echo ""
    echo -e "${YELLOW}Install Docker Desktop from:${NC}"
    echo -e "  ${BLUE}https://www.docker.com/products/docker-desktop${NC}"
    echo ""
    echo -e "${YELLOW}Or install via Homebrew:${NC}"
    echo -e "  ${GREEN}brew install --cask docker${NC}"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Docker is installed${NC}"

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${YELLOW}⚠ Docker is not running${NC}"
    echo ""
    echo -e "${YELLOW}Please start Docker Desktop:${NC}"
    echo -e "  1. Open 'Docker Desktop' from Applications"
    echo -e "  2. Wait for Docker to start (whale icon in menu bar)"
    echo -e "  3. Run this script again"
    echo ""
    echo -e "${BLUE}Opening Docker Desktop...${NC}"
    open -a Docker
    echo ""
    echo -e "${YELLOW}Waiting for Docker to start...${NC}"

    # Wait for Docker to start (max 60 seconds)
    for i in {1..60}; do
        if docker info &> /dev/null; then
            echo -e "${GREEN}✓ Docker started successfully!${NC}"
            sleep 2
            break
        fi
        sleep 1
        echo -n "."
    done
    echo ""

    # Check again
    if ! docker info &> /dev/null; then
        echo -e "${RED}✗ Docker failed to start${NC}"
        echo -e "${YELLOW}Please start Docker Desktop manually and try again${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

# Check if server.cfg exists
if [ ! -f "server.cfg" ]; then
    echo -e "${RED}✗ server.cfg not found${NC}"
    echo -e "${YELLOW}Make sure you're running this from the FiveM server directory${NC}"
    exit 1
fi

echo -e "${YELLOW}Choose how to run the server:${NC}"
echo ""
echo -e "  ${GREEN}1)${NC} Docker Compose (Recommended) - Easy management"
echo -e "  ${GREEN}2)${NC} Direct Docker - Advanced"
echo -e "  ${GREEN}3)${NC} Cancel"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}Starting server with Docker Compose...${NC}"
        echo ""

        if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
            echo -e "${RED}✗ Docker Compose not found${NC}"
            echo -e "${YELLOW}Installing docker-compose...${NC}"
            brew install docker-compose
        fi

        # Stop existing containers
        docker-compose down 2>/dev/null

        # Start the server
        echo -e "${GREEN}Starting FiveM server...${NC}"
        docker-compose up -d

        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✓ Server started successfully!${NC}"
            echo ""
            echo -e "${BLUE}Server Information:${NC}"
            echo -e "  Address: ${GREEN}localhost:30120${NC}"
            echo -e "  Status:  ${GREEN}Running in background${NC}"
            echo ""
            echo -e "${YELLOW}Useful commands:${NC}"
            echo -e "  View logs:    ${GREEN}docker-compose logs -f${NC}"
            echo -e "  Stop server:  ${GREEN}docker-compose down${NC}"
            echo -e "  Restart:      ${GREEN}docker-compose restart${NC}"
            echo ""
            echo -e "${YELLOW}Connect in FiveM:${NC}"
            echo -e "  Press F8 and type: ${GREEN}connect localhost:30120${NC}"
            echo ""

            read -p "Show live logs? (y/n): " show_logs
            if [[ $show_logs == "y" || $show_logs == "Y" ]]; then
                echo ""
                echo -e "${YELLOW}Showing logs (Ctrl+C to exit):${NC}"
                echo ""
                docker-compose logs -f
            fi
        else
            echo -e "${RED}✗ Failed to start server${NC}"
            exit 1
        fi
        ;;
    2)
        echo ""
        ./run-local.sh
        ;;
    3)
        echo ""
        echo -e "${YELLOW}Cancelled${NC}"
        exit 0
        ;;
    *)
        echo ""
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
