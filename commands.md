mix compile

iex --name petnode1@127.0.0.1 -S mix

Registry.start_link(keys: :unique, name: VirtualPetEcosystem.Registry)

VirtualPetEcosystem.Pet.start_link("Fluffy")

VirtualPetEcosystem.Game.start()