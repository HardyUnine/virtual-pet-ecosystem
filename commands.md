cd virtual_pet_ecosystem

mix compile

iex --name petnode1@127.0.0.1 -S mix

<!-- Registry.start_link(keys: :unique, name: VirtualPetEcosystem.Registry) -->

<!-- VirtualPetEcosystem.Pet.start_link("Fluffy") -->

VirtualPetEcosystem.Game.start()


## Double terminal --> distributed 

mix compile

cd virtual_pet_ecosystem

### terminal 1 :
iex --name petnode1@127.0.0.1 --cookie capucine -S mix

### terminal 2 :
iex --name petnode2@127.0.0.1 --cookie capucine -S mix
---
Node.connect(:"petnode1@127.0.0.1")
VirtualPetEcosystem.Pet.feed("Fluffy")
VirtualPetEcosystem.Pet.play("Fluffy")
VirtualPetEcosystem.Pet.status("Fluffy")
