defmodule VirtualPetEcosystemTest do
  use ExUnit.Case
  doctest VirtualPetEcosystem

  test "greets the world" do
    assert VirtualPetEcosystem.hello() == :world
  end
end
