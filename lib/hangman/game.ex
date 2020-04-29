defmodule Hangman.Game do
  defstruct turns_left: 7,
            game_state: :initializing,
            letters: []

  alias __MODULE__

  def new_game() do
    %Game{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end
end
