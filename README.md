# Idle Miner

This is a crypto miner that will mine when the computer is idle. The currently supported detection mechanisms and currencies are listed below. This runs as a user-mode SystemD script, allowing for connection to Dbus.

Idle detection mechanisms:

- Gnome lock screen state

Cryptocurrencies supported:

- ETH (ethminer)

## Requirements

- CUDA/OpenCL (For CUDA: `apt-get install nvidia-cuda-toolkit` on Debian derivatives)

## Usage

`./install.sh $WALLET_ADDRESS`

That is all, now your system will mine to that address while your lock screen is active.

The control process logs can be viewed with: `journalctl --user -u mine-while-idle`

The miner logs can be viewed with: `less /tmp/miner-log`

**NOTE:** You can turn on alerts from the ethermine dashboard for when your system goes offline
