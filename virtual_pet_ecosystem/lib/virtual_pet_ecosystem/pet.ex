defmodule VirtualPetEcosystem.Pet do
  use GenServer

  defstruct [:name, :hunger, :happiness, :health, :node, :last_updated]

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  defp via_tuple(name), do: {:via, Registry, {VirtualPetEcosystem.Registry, name}}


  def feed(pet_name), do: GenServer.cast(via_tuple(pet_name), :feed)
  def play(pet_name), do: GenServer.cast(via_tuple(pet_name), :play)
  def status(pet_name), do: GenServer.call(via_tuple(pet_name), :status)

  def init(name) do
    state = %__MODULE__{
      name: name, hunger: 50, happiness: 50, health: 100,
      node: Node.self(), last_updated: :os.system_time(:second)
    }
    {:ok, state, {:continue, :schedule_tick}}
  end

  def handle_continue(:schedule_tick, state) do
    Process.send_after(self(), :tick, 5000)
    {:noreply, state}
  end

  def handle_cast(:feed, state) do
    new_state = %{state | hunger: min(100, state.hunger + 20), last_updated: :os.system_time(:second)}
    {:noreply, new_state, {:continue, :schedule_tick}}
  end

  def handle_cast(:play, state) do
    new_state = %{
      state |
      happiness: min(100, state.happiness + 15),
      hunger: max(0, state.hunger - 5),
      last_updated: :os.system_time(:second)
    }
    {:noreply, new_state, {:continue, :schedule_tick}}
  end

  def handle_info(:tick, state) do
  new_state = %{
    state |
      hunger: max(0, state.hunger - 5),
      happiness: max(0, state.happiness - 3),
      health:
        max(0,
          state.health -
            if state.hunger < 20 do
              2
            else
              0
            end
        ),
      last_updated: :os.system_time(:second)
  }

  {:noreply, new_state, {:continue, :schedule_tick}}
end


  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end
end
