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

  @spec new_game(binary) :: Game.t()
  def new_game(word),
    do: %Game{
      letters: word |> String.codepoints()
    }

  @spec new_game :: Game.t()
  def new_game do
    new_game(Dictionary.random_word())
  end

  @spec make_move(Game.t(), atom()) ::
          {%{game_state: :already_used | :bad_guess | :good_guess | :lost | :won}, 123}
  def make_move(%{game_state: state} = game, _guess) when state in [:won, :lost] do
    {game, tally(game)}
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    {game, tally(game)}
  end

  @spec accept_move(Game.t(), atom(), boolean()) :: %{
          game_state: :already_used | :bad_guess | :good_guess | :lost | :won
        }
  def accept_move(game, _guess, true = _already_guessed) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  @spec score_guess(Game.t(), boolean()) :: %{game_state: :bad_guess | :good_guess | :lost | :won}
  def score_guess(game, true = _good_guess) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won?()

    Map.put(game, :game_state, new_state)
  end

  def score_guess(%{turns_left: 1} = game, _bad_guess) do
    Map.put(game, :game_state, :lost)
  end

  def score_guess(%{turns_left: turns_left} = game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  def tally(_game) do
    123
  end

  @spec maybe_won?(boolean()) :: :good_guess | :won
  def maybe_won?(true), do: :won
  def maybe_won?(_), do: :good_guess
end
