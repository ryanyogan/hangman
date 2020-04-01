defmodule Hangman do
  alias Hangman.Game
  @spec new_game :: Hangman.Game.t()
  defdelegate new_game(), to: Game

  @spec tally(atom | %{game_state: any, letters: any, turns_left: any, used: any}) :: %{
          game_state: any,
          letters: [any],
          turns_left: any
        }
  defdelegate tally(game), to: Game

  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    {game, tally(game)}
  end
end
