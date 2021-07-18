#!/bin/bash
set -eo pipefail

# Note: Deleting /usr/local/bin/ethminer will result in an automatic update of the miner installation

verify_prerequisites() {
  if ! command -v ethminer &>/dev/null; then
    echo "Cannot find ethminer. Downloading..."
    (
      sudo mkdir -p /opt/ethminer
      cd /opt/ethminer
      sudo curl -Lo ethminer.tar.gz "$(curl -s https://api.github.com/repos/ethereum-mining/ethminer/releases/latest |
        grep "browser_download_url.*cuda-9-linux.*" |
        cut -d '"' -f 4)"
      sudo tar xf ethminer.tar.gz
      sudo rm -f ethminer.tar.gz
      sudo ln -sf /opt/ethminer/bin/ethminer /usr/local/bin/ethminer
      echo "Successfully installed ethminer"
    )
  fi

  if ! command -v screen &>/dev/null; then
    echo "Cannot find screen in \$PATH. Installing..."
    sudo apt-get install -y screen
  fi

}

SERVICE_NAME="mine-while-idle"
SERVICE_FILE_PATH="$HOME/.config/systemd/user/$SERVICE_NAME.service"
WALLET_ADDRESS=$1

cd "$(dirname "$(readlink -f "$0")")"

if [[ $1 == "uninstall" ]]; then
  echo "Uninstalling..."
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

echo "Installing..."
mkdir -p "$HOME/.local/bin"
cp mine-while-idle "$HOME/.local/bin/mine-while-idle"

mkdir -p "$(dirname "$SERVICE_FILE_PATH")"
sed "s/WALLET_ADDRESS/$WALLET_ADDRESS/" service-template >"$SERVICE_FILE_PATH"
systemctl --user enable $SERVICE_NAME
systemctl --user restart $SERVICE_NAME
echo "Successfully installed"
