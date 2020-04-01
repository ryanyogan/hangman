defmodule Hangman do
  alias Hangman.Game
  @spec new_game :: Hangman.Game.t()
  defdelegate new_game(), to: Game
end
