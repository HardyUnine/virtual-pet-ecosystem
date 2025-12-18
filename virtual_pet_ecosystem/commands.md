cd virtual_pet_ecosystem

mix compile

iex --name petnode1@127.0.0.1 -S mix

<!-- Registry.start_link(keys: :unique, name: VirtualPetEcosystem.Registry) -->

<!-- VirtualPetEcosystem.Pet.start_link("Fluffy") -->

VirtualPetEcosystem.Game.start()


## Double terminal --> distributed 
mix compile 
cd virtual_pet_ecosystem
### terminal 1 
iex --name petnode1@127.0.0.1 --cookie secret -S mix

<!-- Application.ensure_all_started(:virtual_pet_ecosystem) -->

<!-- VirtualPetEcosystem.Pet.start_link("Fluffy") -->

VirtualPetEcosystem.Game.start()

### terminal 2 :
cd virtual_pet_ecosystem
iex --name petnode2@127.0.0.1 --cookie secret -S mix

Node.connect(:"petnode1@127.0.0.1")

<!-- Application.ensure_all_started(:virtual_pet_ecosystem) -->

# Remote control of the pet on node1
owner = :"petnode1@127.0.0.1"

VirtualPetEcosystem.Remote.pet_feed("Fluffy", owner)
VirtualPetEcosystem.Remote.pet_play("Fluffy", owner)
VirtualPetEcosystem.Remote.pet_status("Fluffy", owner)

### NEW PET :
# On node1
VirtualPetEcosystem.Pet.start_link("NewFluffy")
# On node2 
VirtualPetEcosystem.Remote.pet_feed("NewFluffy", owner)
VirtualPetEcosystem.Remote.pet_play("NewFluffy", owner)
VirtualPetEcosystem.Remote.pet_status("NewFluffy", owner)
