#!/bin/bash
# Instalador de dependencias para WiFi-Killer-Scan
echo "------------------------------------------"
echo "🛠️ Instalando herramientas de Seguridad..."
echo "------------------------------------------"

sudo apt update
sudo apt install xterm zenity aircrack-ng -y

# Dar permisos de ejecución al script principal
chmod +x killer_scan.sh

echo ""
echo "✅ Instalación completada con éxito."
echo "🚀 Ejecuta la herramienta con: sudo ./killer_scan.sh"
