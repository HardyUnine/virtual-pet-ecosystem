defmodule VirtualPetEcosystem.Game do
  alias VirtualPetEcosystem.Pet

  @default_name "Fluffy"

  # Entry point called from IEx
  def start do
    IO.puts("Welcome to the Distributed Virtual Pet!")
    pet_name = ask_name()
    ensure_pet_started(pet_name)
    loop(pet_name)
  end

  # Ask the user to choose a pet name (with a default)
  defp ask_name do
    name =
      IO.gets("Choose a name for your pet (leave empty for #{@default_name}): ")
      |> case do
        nil ->
          @default_name

        input ->
          case String.trim(input) do
            "" -> @default_name
            other -> other
          end
      end

    IO.puts("Your pet's name is #{name}!")
    name
  end

  # Ensure there is a Pet process registered under this name
  defp ensure_pet_started(name) do
    case Pet.start_link(name) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end
  end

  # Main interactive loop, parameterized by pet_name
  defp loop(pet_name) do
    IO.puts("\nChoose an action:")
    IO.puts("1) Status")
    IO.puts("2) Feed")
    IO.puts("3) Play")
    IO.puts("4) Quit")

    case IO.gets("> ") |> parse_input() do
      :status ->
        show_status(pet_name)
        loop(pet_name)

      :feed ->
        Pet.feed(pet_name)
        IO.puts("You fed #{pet_name}.")
        loop(pet_name)

      :play ->
        Pet.play(pet_name)
        IO.puts("You played with #{pet_name}.")
        loop(pet_name)

      :quit ->
        IO.puts("Goodbye!")

      :invalid ->
        IO.puts("Invalid choice, try again.")
        loop(pet_name)
    end
  end

  # Treat EOF (Ctrl+D) as quit
  defp parse_input(nil), do: :quit

  # Convert menu choices into command atoms
  defp parse_input(input) do
    case String.trim(input) do
      "1" -> :status
      "2" -> :feed
      "3" -> :play
      "4" -> :quit
      _ -> :invalid
    end
  end

  # Show the pet's current state and mood; if dead, exit after showing once
  defp show_status(pet_name) do
    pet = Pet.status(pet_name)
    now = :os.system_time(:second)
    seconds_since = now - pet.last_updated

    {face, message} =
      cond do
        pet.health <= 0 ->
          {
            """
             x_x
            """,
            "I... don’t feel so good..."
          }

        pet.hunger <= 20 ->
          {
            """
             (>_<)
            """,
            "I’m starving!"
          }

        pet.hunger <= 50 ->
          {
            """
             (._.)
            """,
            "I’m hungry..."
          }

        pet.happiness <= 50 ->
          {
            """
             (._.)
            """,
            "I’m feeling a bit sad..."
          }

        true ->
          {
            """
             (^_^)
            """,
            "I’m feeling great!"
          }
      end

    IO.puts("""
    ---
    Pet: #{pet.name}
    Hunger:    #{pet.hunger}
    Happiness: #{pet.happiness}
    Health:    #{pet.health}
    Node:      #{inspect(pet.node)}
    Last tick: #{seconds_since}s ago
    Mood:
    #{face}
    "#{message}"
    ---
    """)

    if pet.health <= 0 do
      IO.puts("\nYour pet has died. The game will now exit.\n")
      System.halt(0)
    end
  end
end
