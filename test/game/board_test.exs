defmodule RealtimeChess.Game.GameStateTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Board

  describe ".in_check?/2" do
    test "takes a Board and a color and returns true if King of given color is in check" do
      blank_board = Board.blank_board()

      pieces = [
        %{piece: {:white, :king}, position: {3, 5}},
        %{piece: {:black, :queen}, position: {3, 3}},
        %{piece: {:black, :king}, position: {1, 1}}
      ]

      board = Enum.reduce(pieces, blank_board, fn data, board ->
         Board.insert_piece(board, data.position, data.piece)
      end)

      assert Board.in_check?(board, :white) == true
      assert Board.in_check?(board, :black) == false

      board = Board.insert_piece(board, {3, 4}, {:white, :pawn})
      assert Board.in_check?(board, :white) == false

      board = Board.insert_piece(board, {5, 4}, {:black, :knight})
      assert Board.in_check?(board, :white) == true

      board = Board.insert_piece(board, {7, 1}, {:white, :rook})
      assert Board.in_check?(board, :black) == true
    end
  end
end
