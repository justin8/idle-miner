#!/bin/bash
set -eo pipefail

verify_prerequisites() {
  if ! which PhoenixMiner &>/dev/null; then
    echo "Cannot find PhoenixMiner in \$PATH. Please install it first"
    exit 1
  fi
}


SERVICE_NAME="mine-while-idle"
SERVICE_FILE_PATH="$HOME/.local/share/systemd/user/$SERVICE_NAME.service"
WALLET_ADDRESS=$1

cd "$(dirname "$(readlink -f "$0")")"

if [[ $1 == "uninstall" ]]; then
  systemctl --user disable --now $SERVICE_NAME
  rm "$SERVICE_FILE_PATH"
  exit 0
fi

if ! [[ $WALLET_ADDRESS =~ 0x.{40}$ ]]; then
  echo "Usage:"
  echo "./install.sh <WALLET_ADDRESS>"
  echo "./install.sh uninstall"
  echo "You must provide an Ethereum wallet address to install this service"
  exit 1
fi

# Fail on unbound variables after init
set -u

verify_prerequisites

mkdir -p "$HOME/.local/bin"
cp mine-while-idle "$HOME/.local/bin/mine-while-idle"

mkdir -p "$(dirname "$SERVICE_FILE_PATH")"
sed "s/WALLET_ADDRESS/$WALLET_ADDRESS/" service-template > "$SERVICE_FILE_PATH"
systemctl --user enable --now $SERVICE_NAME
