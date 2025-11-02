#!/bin/bash
# Quick server status checker

echo "=== FiveM Server Status ==="
echo ""

echo "Production Server (109.123.240.14:30120):"
if nc -zv 109.123.240.14 30120 2>&1 | grep -q "succeeded"; then
    echo "✅ Server is ONLINE and accessible"
else
    echo "❌ Server is OFFLINE or unreachable"
fi

echo ""
echo "Checking running processes..."
sshpass -p 'atM76wMuVEkm' ssh -o StrictHostKeyChecking=no root@109.123.240.14 'ps aux | grep FXServer | grep -v grep | wc -l' | {
    read count
    if [ "$count" -gt 0 ]; then
        echo "✅ FXServer is running ($count processes)"
    else
        echo "❌ FXServer is not running"
    fi
}

echo ""
echo "Active resources:"
sshpass -p 'atM76wMuVEkm' ssh -o StrictHostKeyChecking=no root@109.123.240.14 'su - fivem -c "screen -S fivem -X hardcopy /tmp/status.txt && grep \"Started resource\" /tmp/status.txt | tail -10"'

echo ""
echo "Server configuration:"
echo "  - Name: Legacy Romania"
echo "  - Logo: 96x96 PNG (13KB)"
echo "  - Max Players: 32"
echo "  - Custom Resources: character-creator, player-persistence, no-npcs"
echo ""
echo "Local Dev Server:"
echo "  - Name: Legacy Romania - Dev"
echo "  - Password: dev123"
echo "  - Config: server-dev.cfg"
echo "  - Start with: ./start-local.sh or ./fivem.sh"
