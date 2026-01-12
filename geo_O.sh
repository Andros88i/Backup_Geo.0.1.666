#!/bin/bash

# =========================================================
# CONFIGURACIÓN
# =========================================================
HOST="127.0.0.1"
PORT="9999"
IMG="/data/data/com.termux/files/home/storage/pictures/Anonymus.png"

# Colores
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# =========================================================
# BANNER (IMAGEN REAL)
# =========================================================
clear

if command -v chafa >/dev/null 2>&1 && [ -f "$IMG" ]; then
    chafa --center=on --size=60x30 "$IMG"
else
    echo -e "${RED}[!] No se pudo cargar la imagen o chafa no está instalado${NC}"
fi

echo
echo -e "${LRED}      [+] CREADOR : Andro_Os${NC}"
echo -e "${LRED}      [+] PROYECTO: Geo-Auto Final${NC}"
echo -e "${LRED}      [+] ESTADO  : ${GREEN}ACTIVO${NC}"
echo -e "${LRED}=================================================${NC}"

# =========================================================
# AUTOMATIZACIÓN
# =========================================================

pkill -f cloudflared > /dev/null 2>&1
pkill -f "python server.py" > /dev/null 2>&1

echo -e "${GREEN}[*] Generando enlace seguro... Por favor espere...${NC}"
cloudflared tunnel --url $HOST:$PORT --logfile /dev/null > cf_log.txt 2>&1 &
CF_PID=$!

sleep 6

ENLACE=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' cf_log.txt | head -n 1)

if [ -z "$ENLACE" ]; then
    echo -e "${RED}[!] Error obteniendo enlace. Reintentando...${NC}"
    sleep 3
    ENLACE=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' cf_log.txt | head -n 1)
fi

echo -e "${LRED}=================================================${NC}"
echo -e "${GREEN}[✔] ENLACE GENERADO EXITOSAMENTE:${NC}"
echo -e "\n${LRED}    $ENLACE ${NC}\n"
echo -e "${LRED}=================================================${NC}"
echo -e "${GREEN}[*] Esperando conexiones... (Ctrl+C para salir)${NC}"

python server.py

kill $CF_PID > /dev/null 2>&1
rm cf_log.txt
