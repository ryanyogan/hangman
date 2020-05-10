defmodule Hangman do
  alias Hangman.Game

  @moduledoc """
  Hangman provides a clean API boundary into the Hangman.Game module.
  """

  defdelegate new_game(), to: Game
  defdelegate tally(game), to: Game

  defdelegate make_move(game, move), to: Game
end
