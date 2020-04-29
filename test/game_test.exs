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
end
