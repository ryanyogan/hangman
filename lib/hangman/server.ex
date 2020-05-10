defmodule Hangman.Server do
  @me __MODULE__

  alias Hangman.Game
  use GenServer

  # This is our own API
  def start_link(_) do
    GenServer.start_link(@me, nil)
  end

  @impl true
  def init(_args) do
    {:ok, Game.new_game()}
  end

  @impl true
  def handle_call({:make_move, guess}, _from, game) do
    {game, tally} = Game.make_move(game, guess)
    {:reply, tally, game}
  end

  @impl true
  def handle_call({:tally}, _from, game) do
    {:reply, Game.tally(game), game}
  end
end
