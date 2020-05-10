defmodule Hangman do
  @moduledoc """
  Hangman provides a clean API boundary into the Hangman.Game module.
  """

  def new_game() do
    {:ok, game} = DynamicSupervisor.start_child(Hangman.Supervisor, Hangman.Server)
    game
  end

  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end
end
