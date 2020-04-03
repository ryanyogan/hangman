defmodule Hangman.Server do
  alias Hangman.Game
  use GenServer

  @me __MODULE__

  def start_link() do
    GenServer.start_link(@me, nil)
  end

  def child_spec(_opts) do
    %{
      id: Hangman.Server,
      start: {__MODULE__, :start_link, []},
      shutdown: 5_000,
      restart: :permanent,
      type: :worker
    }
  end

  def init(_args) do
    {:ok, Game.new_game()}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {game, tally} = Game.make_move(game, guess)

    {:reply, tally, game}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Game.tally(game), game}
  end
end
