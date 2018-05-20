defmodule RealtimeChess.Game.QueenTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Queen

  describe "Queen.move_positions/2" do
    test "returns a set with the positions a queen can move" do
      #{5, 6}, {5, 4}, {6, 5}, {4, 5}, {6, 6}, {4, 4}
    end
  end
end
