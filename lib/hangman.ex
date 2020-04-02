defmodule Hangman do
  alias Hangman.Game
  @spec new_game :: Hangman.Game.t()
  defdelegate new_game(), to: Game

  defdelegate tally(game), to: Game

  defdelegate make_move(game, guess), to: Game
end
