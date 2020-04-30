defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns Game structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0

    for letter <- game.letters do
      assert letter =~ ~r/[a-z]/
    end
  end

  test "game state is not changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)

      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()

    game = Game.make_move(game, "x")
    assert game.game_state != :already_used

    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")

    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    moves = [
      {"w", :good_guess, 7},
      {"i", :good_guess, 7},
      {"b", :good_guess, 7},
      {"l", :good_guess, 7},
      {"e", :won, 7}
    ]

    new_game = Game.new_game("wibble")

    Enum.reduce(
      moves,
      new_game,
      fn {guess, game_state, turns_left}, game ->
        game = Game.make_move(game, guess)
        assert game.game_state == game_state
        assert game.turns_left == turns_left
        game
      end
    )
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "seven bad guesses results in a loss" do
    moves = [
      {"a", :bad_guess, 6},
      {"b", :bad_guess, 5},
      {"c", :bad_guess, 4},
      {"d", :bad_guess, 3},
      {"e", :bad_guess, 2},
      {"f", :bad_guess, 1},
      {"g", :lost, 1}
    ]

    new_game = Game.new_game("w")

    Enum.reduce(
      moves,
      new_game,
      fn {guess, game_state, turns_left}, game ->
        game = Game.make_move(game, guess)
        assert game.game_state == game_state
        assert game.turns_left == turns_left
        game
      end
    )
  end
end
