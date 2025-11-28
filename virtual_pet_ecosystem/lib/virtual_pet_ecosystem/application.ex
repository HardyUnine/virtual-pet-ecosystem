defmodule VirtualPetEcosystem.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Registry for locating the single shared pet by name
      {Registry, keys: :unique, name: VirtualPetEcosystem.Registry},
      # Single shared pet process
      {VirtualPetEcosystem.Pet, "Fluffy"}
    ]

    opts = [strategy: :one_for_one, name: VirtualPetEcosystem.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
