#!/bin/bash

# FiveM Server Management Script
# Manages both local (Docker) and remote (Ubuntu) servers

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SERVER_IP="109.123.240.14"
SERVER_USER="root"
SERVER_PASS="atM76wMuVEkm"

show_banner() {
    clear
    echo -e "${CYAN}"
    echo "  ╔═══════════════════════════════════════════════╗"
    echo "  ║      FiveM Server Management Tool            ║"
    echo "  ║           Legacy Romania                     ║"
    echo "  ╚═══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_menu() {
    echo ""
    echo -e "${YELLOW}Local Server (Docker):${NC}"
    echo -e "  ${GREEN}1)${NC} Start local server"
    echo -e "  ${GREEN}2)${NC} Stop local server"
    echo -e "  ${GREEN}3)${NC} View local logs"
    echo -e "  ${GREEN}4)${NC} Restart local server"
    echo ""
    echo -e "${YELLOW}Remote Server (${SERVER_IP}):${NC}"
    echo -e "  ${GREEN}5)${NC} Deploy to remote server"
    echo -e "  ${GREEN}6)${NC} Check remote server status"
    echo -e "  ${GREEN}7)${NC} View remote logs"
    echo -e "  ${GREEN}8)${NC} Restart remote server"
    echo -e "  ${GREEN}9)${NC} SSH into remote server"
    echo ""
    echo -e "${YELLOW}Other:${NC}"
    echo -e "  ${GREEN}0)${NC} Exit"
    echo ""
}

local_start() {
    echo -e "${BLUE}Starting local server...${NC}"
    if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
        docker-compose up -d
        echo -e "${GREEN}✓ Local server started${NC}"
        echo -e "  Connect: ${CYAN}localhost:30120${NC}"
    else
        echo -e "${RED}✗ Docker Compose not found${NC}"
        echo -e "${YELLOW}Run ./start-local.sh instead${NC}"
    fi
}

local_stop() {
    echo -e "${BLUE}Stopping local server...${NC}"
    docker-compose down
    echo -e "${GREEN}✓ Local server stopped${NC}"
}

local_logs() {
    echo -e "${BLUE}Showing local logs (Ctrl+C to exit)...${NC}"
    echo ""
    docker-compose logs -f
}

local_restart() {
    echo -e "${BLUE}Restarting local server...${NC}"
    docker-compose restart
    echo -e "${GREEN}✓ Local server restarted${NC}"
}

remote_deploy() {
    echo -e "${BLUE}Deploying to remote server...${NC}"
    ./deploy.sh
}

remote_status() {
    echo -e "${BLUE}Checking remote server status...${NC}"
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" \
        "systemctl status fivem --no-pager"
}

remote_logs() {
    echo -e "${BLUE}Showing remote logs (Ctrl+C to exit)...${NC}"
    echo ""
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" \
        "tail -f /var/log/fivem.log"
}

remote_restart() {
    echo -e "${BLUE}Restarting remote server...${NC}"
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" \
        "systemctl restart fivem"
    sleep 3
    remote_status
}

remote_ssh() {
    echo -e "${BLUE}Connecting to remote server...${NC}"
    echo -e "${YELLOW}Type 'exit' to return${NC}"
    echo ""
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP"
}

# Main loop
while true; do
    show_banner
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1) local_start ;;
        2) local_stop ;;
        3) local_logs ;;
        4) local_restart ;;
        5) remote_deploy ;;
        6) remote_status ;;
        7) remote_logs ;;
        8) remote_restart ;;
        9) remote_ssh ;;
        0)
            echo ""
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac

    if [ $choice != "3" ] && [ $choice != "7" ] && [ $choice != "9" ]; then
        echo ""
        read -p "Press Enter to continue..."
    fi
done
