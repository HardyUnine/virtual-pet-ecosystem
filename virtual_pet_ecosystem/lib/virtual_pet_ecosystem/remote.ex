defmodule VirtualPetEcosystem.Remote do
  """
  Helpers for calling into a pet-owning node from other nodes.
  """

  def pet_status(name, owner_node) do
    :rpc.call(owner_node, VirtualPetEcosystem.Pet, :status, [name])
  end
  def pet_feed(name, owner_node) do
    :rpc.call(owner_node, VirtualPetEcosystem.Pet, :feed, [name])
  end
  def pet_play(name, owner_node) do
    :rpc.call(owner_node, VirtualPetEcosystem.Pet, :play, [name])
  end
end
