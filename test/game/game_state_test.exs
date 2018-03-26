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
end
