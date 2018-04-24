defmodule RealtimeChess.Game.GameStateTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.GameState
  alias RealtimeChess.Game

  setup do
    game_state = %Game{name: "testgame"}
    %{game_state: game_state}
  end

  test "updates the game name", %{game_state: game_state} do
    assert Map.get(game_state, :name) == "testgame"
    new_game_state = GameState.update_name(game_state, "newname")
    assert Map.get(new_game_state, :name) == "newname"
  end

  test "initializes board", %{game_state: game_state} do
    board = GameState.initialize_board(game_state).board

    assert board |> Map.keys |> length == 8

    assert board
      |> Map.values
      |> Enum.all?(fn row ->
        row |> Map.keys |> length == 8
      end)

    assert {:white, :king} == board[0][4]
    assert {:black, :knight} == board[7][1]
    assert {:black, :pawn} == board[6][1]
  end

  test "moves a piece", %{game_state: game_state} do
    new_state = GameState.initialize_board(game_state)
    |> GameState.move_piece(%{current_position: {1,0}, new_position: {2,2}})
    assert {:white, :pawn} == new_state.board[2][2]
  end

  test "get surrounding pieces", %{game_state: game_state} do
    initialized_board = GameState.initialize_board(game_state)
    piece_position = {3, 3}

    #   0 1 2 3 4 5 6 7
    # 0 x x x x x x x x
    # 1 x x x x x x x x
    # 2 x 1 1 1 1 1 x x
    # 3 x 1 x x x 1 x x
    # 4 x 1 x Q x 1 x x
    # 5 x 1 x x x 1 x x
    # 6 x 1 1 1 1 1 x x
    # 7 x x x x x x x x

    surrounding_pieces = MapSet.new([
      {:white, :pawn, {2, 1}},
      {:black, :pawn, {2, 2}},
      {:white, :pawn, {2, 3}},
      {:black, :pawn, {2, 4}},
      {:white, :pawn, {2, 5}},
      {:black, :pawn, {3, 1}},
      {:white, :pawn, {4, 1}},
      {:black, :pawn, {5, 1}},
      {:white, :pawn, {6, 1}},
      {:black, :pawn, {6, 2}},
      {:white, :pawn, {6, 3}},
      {:black, :pawn, {6, 4}},
      {:white, :pawn, {6, 5}},
      {:black, :pawn, {3, 5}},
      {:white, :pawn, {4, 5}},
      {:black, :pawn, {5, 5}}
    ])

    assert GameState.get_surrounding_pieces(initialized_board, piece_position) == surrounding_pieces
  end
end
