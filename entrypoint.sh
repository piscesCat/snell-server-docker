#!/bin/bash

BIN="/app/snell-server"
CONF="/app/snell-server.conf"

get_host_ip() {
  HOST_IP=$(hostname -I | awk '{print $1}')
  echo "Server IP: ${HOST_IP}"
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

  get_host_ip
  echo -e "Starting snell-server...\n"
  echo "Config:"
  cat ${CONF}
  echo ""
  ${BIN} -c ${CONF}
}

run
