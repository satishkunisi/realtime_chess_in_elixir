defmodule RealtimeChess.Game.KingTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.King

  describe "King.move_positions/2" do
    test "returns a set with the eight positions a king can move from any given starting position" do
      assert MapSet.new([{4, 3}, {2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]) == King.move_positions({3 ,3}, :white)
      assert MapSet.new([{4, 3}, {2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]) == King.move_positions({3 ,3}, :black)
    end


    test "returns a set with the eight positions a king can attack from any given starting position" do
      assert MapSet.new([{4, 3}, {2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]) == King.attack_positions({3 ,3}, :white)
      assert MapSet.new([{4, 3}, {2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]) == King.attack_positions({3 ,3}, :black)
    end
  end
end
