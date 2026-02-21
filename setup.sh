#!/bin/bash
echo "Instalando dependencias..."
sudo apt update && sudo apt install xterm zenity aircrack-ng -y
chmod +x killer_scan.sh
echo "Listo. Ejecuta con: sudo ./killer_scan.sh"
