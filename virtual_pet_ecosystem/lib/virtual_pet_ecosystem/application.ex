defmodule VirtualPetEcosystem.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    # List of processes supervised by the top-level Supervisor
    children = [
      # Registry for name-based lookup of pets
      {Registry, keys: :unique, name: VirtualPetEcosystem.Registry}
      # We no longer start a Pet here, Game.start/0 will start it
      # {VirtualPetEcosystem.Pet, "Fluffy"}
    ]

    opts = [strategy: :one_for_one, name: VirtualPetEcosystem.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
