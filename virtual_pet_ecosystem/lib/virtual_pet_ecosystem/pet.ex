defmodule VirtualPetEcosystem.Pet do
  # Declare this module as a GenServer (generic server process managed by OTP)
  use GenServer

  # :node -> which node (BEAM VM) the pet process is running on
  # :last_updated -> timestamp of the last state change / tick
  defstruct [:name, :hunger, :happiness, :health, :node, :last_updated]


  # Starts the GenServer for a pet with the given name
  # __MODULE__ is this module, "name" is passed to init/1
  # "name: via_tuple(name)" registers the process in the Registry under that name
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  # Build a "via" tuple so the process can be looked up in the Registry by name
  # This avoids using raw PIDs everywhere, I wanna call the pet fluffy and then just recall for fluffy, not the PID for the pet "fluffy"
  defp via_tuple(name), do: {:via, Registry, {VirtualPetEcosystem.Registry, name}}

  # Asynchronous request: ask the pet to be fed, no reply expected
  def feed(pet_name), do: GenServer.cast(via_tuple(pet_name), :feed)

  # Asynchronous request: ask the pet to play, no reply expected
  def play(pet_name), do: GenServer.cast(via_tuple(pet_name), :play)

  # Synchronous request: ask for the full current state, waits for a reply
  def status(pet_name), do: GenServer.call(via_tuple(pet_name), :status)

  # --- GenServer callbacks (server-side behavior) ---

  # Called once when the GenServer starts
  # "name" is the argument given to start_link/1
  def init(name) do
    # Build initial state with default stats
    state = %__MODULE__{
      name: name,
      hunger: 50,
      happiness: 50,
      health: 100,
      node: Node.self(),
      last_updated: :os.system_time(:second)
    }

    # :continue tells OTP to immediately call handle_continue/2
    {:ok, state, {:continue, :schedule_tick}}
  end

  # Called right after init/1 because of the :continue instruction
  # Used here to schedule the first periodic :tick message
  def handle_continue(:schedule_tick, state) do
    # After 5000 ms (5s), send :tick to this process
    Process.send_after(self(), :tick, 5000)
    {:noreply, state}
  end

  # Handle asynchronous "feed" commands
  def handle_cast(:feed, state) do
    # Increase hunger by 20, but cap at 100, and update timestamp
    new_state = %{
      state
      | hunger: min(100, state.hunger + 20),
        last_updated: :os.system_time(:second)
    }

    # No reply (cast), update state and schedule next tick again
    {:noreply, new_state, {:continue, :schedule_tick}}
  end

  # Handle asynchronous "play" commands
  def handle_cast(:play, state) do
    # Increase happiness, slightly decrease hunger, update timestamp
    new_state = %{
      state
      | happiness: min(100, state.happiness + 15),
        hunger: max(0, state.hunger - 5),
        last_updated: :os.system_time(:second)
    }

    {:noreply, new_state, {:continue, :schedule_tick}}
  end

 def handle_info(:tick, state) do
  new_state = %{
    state
    | hunger: max(0, state.hunger - 5),
      happiness: max(0, state.happiness - 3),
      health:
        max(
          0,
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



  # Handle synchronous "status" requests
  # _from is the caller (ignored here), state is the current pet struct
  def handle_call(:status, _from, state) do
    # Reply with the full state, keep state unchanged
    {:reply, state, state}
  end
end
