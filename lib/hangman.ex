defmodule Hangman do
  alias Hangman.Game

  @moduledoc """
  Hangman provides a clean API boundary into the Hangman.Game module.
  """

  defdelegate new_game(), to: Game
  defdelegate tally(game), to: Game

  # Don't know if I like this delegation method in the API interface, TBD
  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    {game, tally(game)}
  end
end
