# Distributed Virtual Pet Ecosystem

A Tamagotchi-style virtual pet game built with Elixir and OTP, supporting multi-node distributed gameplay across multiple BEAM nodes.

## Overview

This project demonstrates core distributed systems and concurrent programming concepts using Elixir's GenServer, Registry, Supervisor, and RPC mechanisms. Players can interact with their virtual pet through a terminal interface, with pet state persisted via a long-lived GenServer process. Multiple remote nodes can control the same pet across a network using distributed RPC calls.

## Features

- **Autonomous Pet State Management** — GenServer-based pet process with automatic state decay via timed ticks
- **Interactive Terminal UI** — Simple menu-driven interface for pet interactions (feed, play, status)
- **Multi-Node Support** — Control pets remotely from other BEAM nodes using RPC
- **Fault Tolerance** — Supervisor automatically restarts crashed pet processes
- **Name-Based Lookup** — Registry enables stable name-based pet access without managing PIDs
- **Pet Lifecycle** — Pet dies when health reaches zero; players can adopt new pets

## Installation & Setup

### Prerequisites

- Elixir >= 1.19
- Erlang/OTP >= 26

### Build

```bash
git clone https://github.com/yourusername/virtual_pet_ecosystem.git
cd virtual_pet_ecosystem
mix deps.get
```

## Usage

### Single-Node Game

Start an interactive Elixir session and run the game:

```bash
iex -S mix
iex(1)> VirtualPetEcosystem.Game.start()
Welcome to the Distributed Virtual Pet!
Choose a name for your pet (leave empty for Fluffy): 
```

Follow the menu prompts to interact with your pet.

### Multi-Node Gameplay

#### Terminal 1: Owner Node

```bash
iex --name petnode1@127.0.0.1 --cookie secret -S mix

iex(petnode1@127.0.0.1)> Application.ensure_all_started(:virtual_pet_ecosystem)
iex(petnode1@127.0.0.1)> VirtualPetEcosystem.Game.start()
```

This starts the pet on node1 and begins interactive gameplay.

#### Terminal 2: Remote Controller Node

```bash
iex --name petnode2@127.0.0.1 --cookie secret -S mix

iex(petnode2@127.0.0.1)> Node.connect(:"petnode1@127.0.0.1")
iex(petnode2@127.0.0.1)> Application.ensure_all_started(:virtual_pet_ecosystem)
```

Control the pet remotely:

```elixir
iex(petnode2@127.0.0.1)> VirtualPetEcosystem.Remote.pet_feed("Fluffy", :"petnode1@127.0.0.1")
iex(petnode2@127.0.0.1)> VirtualPetEcosystem.Remote.pet_play("Fluffy", :"petnode1@127.0.0.1")
iex(petnode2@127.0.0.1)> VirtualPetEcosystem.Remote.pet_status("Fluffy", :"petnode1@127.0.0.1")
```

## Architecture

### Core Components

**VirtualPetEcosystem.Pet**
- GenServer managing pet state (hunger, happiness, health)
- Automatic tick-based state decay every 5 seconds
- Responds to feed/play casts and status calls

**VirtualPetEcosystem.Game**
- Terminal UI with interactive menu
- Manages game loop and player input
- Detects pet death and handles pet adoption

**VirtualPetEcosystem.Remote**
- RPC wrappers for cross-node pet control
- Enables remote nodes to call Pet functions on the owner node
- Workaround for Registry's per-node limitation

**VirtualPetEcosystem.Application**
- OTP Application that starts Registry and Supervisor
- Registry enables name-based pet lookup (`:via` tuple pattern)
- Supervisor restarts crashed pets automatically (`:one_for_one` strategy)

### Pet State

```elixir
defstruct [
  :name,           # Pet's name
  :hunger,         # 0-100
  :happiness,      # 0-100
  :health,         # 0-100
  :node,           # BEAM node where pet runs
  :last_updated    # UNIX timestamp of last update
]
```

### Interaction Model

- **feed**: Reduces hunger by 20 (async cast)
- **play**: Increases happiness by 15, reduces hunger by 5 (async cast)
- **status**: Returns full pet state (sync call)
- **tick**: Automatic decay every 5 seconds (triggered by Process.send_after)

## References

- [Elixir GenServer Documentation](https://hexdocs.pm/elixir/GenServer.html)
- [Elixir Registry Documentation](https://hexdocs.pm/elixir/Registry.html)
- [Learn You Some Erlang: Distributed OTP Applications](https://learnyousomeerlang.com/distributed-otp-applications)
- [Erlang Distributed Documentation](https://www.erlang.org/doc/system/distributed.html)

## Authors

Angeliki Andreadi, Keenan Hardy

**Course:** Distributed and Concurrent Systems, University of Neuchâtel

**Semester:** Autumn 2025

## License

MIT License
