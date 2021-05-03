# Idle Miner

This is a crypto miner that will mine when the computer is idle. The currently supported detection mechanisms and currencies are listed below. This runs as a user-mode SystemD script, allowing for connection to Dbus.

Idle detection mechanisms:

- Gnome lock screen state

Cryptocurrencies supported:

- ETH (PhoenixMiner)

## Requirements

- PhoenixMiner (Have it available in the path)
  - CUDA/OpenCL
