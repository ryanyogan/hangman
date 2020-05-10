defmodule Hangman.Game do
  alias __MODULE__

  @moduledoc """
    Hangman.Game represents the core logic of the Hangman game, which
    includes handling the state of turns, current guess, a word broken
    down into letters, and the used or "gussed" letters.
  """

  @typedoc """
    Type that represents a Game struct with turns_left as :integer,
    :game_state as atom, :letters as list, :used as MapSet()
  """
  @type t :: %Game{
          turns_left: integer(),
          game_state: atom(),
          letters: list(),
          used: MapSet.t()
        }
  defstruct turns_left: 7,
            game_state: :initializing,
            letters: [],
            used: MapSet.new()

  # Public API Functions

  @spec new_game(binary) :: Game.t()
  def new_game(word),
    do: %Game{
      letters: word |> String.codepoints()
    }

  @spec new_game :: Game.t()
  def new_game do
    Dictionary.start()
    |> Dictionary.random_word()
    |> new_game()
  end

  def make_move(%{game_state: state} = game, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used)
    }
  end

  # Private Internals

  defp accept_move(game, _guess, true = _already_guessed) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, true = _good_guess) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won?()

    Map.put(game, :game_state, new_state)
  end

  defp score_guess(%{turns_left: 1} = game, _bad_guess) do
    Map.put(game, :game_state, :lost)
  end

  defp score_guess(%{turns_left: turns_left} = game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, true = _in_word), do: letter
  defp reveal_letter(_letter, _not_in_word), do: "_"

  defp maybe_won?(true), do: :won
  defp maybe_won?(_), do: :good_guess

  defp return_with_tally(game),
    do: {game, tally(game)}
end
