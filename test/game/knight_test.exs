defmodule RealtimeChess.Game.KnightTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Knight

  setup do
    expected_positions = [{4, 5}, {2, 5}, {2, 1}, {4, 1}, {5, 4}, {1, 4}, {1, 2}, {5, 2}]
    %{expected_positions: expected_positions}
  end

  describe "Knight.move_positions/2" do
    test "returns a set with the four positions a knight can move from any given starting position", %{expected_positions: expected_positions} do
      assert MapSet.new(expected_positions) == Knight.move_positions({3, 3}, :white)
      assert MapSet.new(expected_positions) == Knight.move_positions({3, 3}, :black)
    end
  end

  describe "Knight.attack_positions/2" do
    test "returns a set with the four positions a knight can attack from any given starting position", %{expected_positions: expected_positions} do
      assert MapSet.new(expected_positions) == Knight.move_positions({3, 3}, :white)
      assert MapSet.new(expected_positions) == Knight.move_positions({3, 3}, :black)
    end
  end
end
