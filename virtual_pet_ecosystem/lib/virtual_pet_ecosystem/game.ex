defmodule VirtualPetEcosystem.Game do
  alias VirtualPetEcosystem.Pet

  def start do
    IO.puts("Welcome to the Distributed Virtual Pet!")
    loop()
  end

  defp loop do
    IO.puts("\nChoose an action:")
    IO.puts("1) Status")
    IO.puts("2) Feed")
    IO.puts("3) Play")
    IO.puts("4) Quit")

    case IO.gets("> ") |> parse_input() do
      :status ->
        show_status()
        loop()

      :feed ->
        Pet.feed("Fluffy")
        IO.puts("You fed Fluffy.")
        loop()

      :play ->
        Pet.play("Fluffy")
        IO.puts("You played with Fluffy.")
        loop()

      :quit ->
        IO.puts("Goodbye!")

      :invalid ->
        IO.puts("Invalid choice, try again.")
        loop()
    end
  end

  defp parse_input(nil), do: :quit

  defp parse_input(input) do
    case String.trim(input) do
      "1" -> :status
      "2" -> :feed
      "3" -> :play
      "4" -> :quit
      _ -> :invalid
    end
  end

  defp show_status do
    pet = Pet.status("Fluffy")
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
end
end
