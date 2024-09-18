#!/bin/bash

BIN="/app/snell-server"
CONF="/app/snell-server.conf"

get_public_ip() {
  PUBLIC_IP=$(wget -qO- http://kiemtraip.com/raw.php)
  echo "Public IP: ${PUBLIC_IP}"
}

run() {
  if [ ! -f ${CONF} ]; then
    PSK=${PSK:-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 31)}
    PORT=${PORT:-6180}
    IPV6=${IPV6:-false}

    echo "Using PSK: ${PSK}"
    echo "Using port: ${PORT}"
    echo "Using ipv6: ${IPV6}"

    echo "Generating new config..."
    cat << EOF > ${CONF}
[snell-server]
listen = 0.0.0.0:${PORT}
psk = ${PSK}
ipv6 = ${IPV6}
EOF
  fi

  get_public_ip
  echo -e "Starting snell-server...\n"
  echo "Config:"
  cat ${CONF}
  echo ""
  ${BIN} -c ${CONF}
}

run
