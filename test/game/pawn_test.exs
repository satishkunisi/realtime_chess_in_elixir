defmodule RealtimeChess.Game.PawnTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Pawn

  describe "Pawn.move_positions/1" do
    test "returns a set with the one position a pawn can move from any given starting position" do
      assert MapSet.new([{4, 3}]) == Pawn.move_positions({3, 3}, :white)
      assert MapSet.new([{4, 2}]) == Pawn.move_positions({5, 2}, :black)
    end

    test "returns a set with the two positions a pawn can move from the starting row" do
      assert MapSet.new([{3, 3}, {2, 3}]) == Pawn.move_positions({1, 3}, :white)
      assert MapSet.new([{4, 7}, {5, 7}]) == Pawn.move_positions({6, 7}, :black)
    end

    test "returns a set with the two positions a pawn can attack" do
      assert MapSet.new([{6, 6}, {6, 4}]) == Pawn.attack_positions({5, 5}, :white)
      assert MapSet.new([{4, 6}, {4, 4}]) == Pawn.attack_positions({5, 5}, :black)
    end
  end
end
