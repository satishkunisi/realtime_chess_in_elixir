defmodule RealtimeChess.Game.GameState do
  alias RealtimeChess.Game

  @spec initialize_board(Game.t) :: Game.t 
  def initialize_board(game_state) do 
    board = blank_board 
    |> populate_board 

    %Game{game_state | board: board}
  end

  @spec blank_board :: board 
  def blank_board do
    add_row(%{}, 0)
  end

  @spec update_name(Game.t, String.t) :: Game.t 
  def update_name(%Game{} = game_state, new_name) do
    Map.put(game_state, :name, new_name)
  end

  @spec move_piece(Game.t, %{current_position: position, new_position: position}) :: Game.t
  def move_piece(%Game{} = game, %{current_position: current_position, new_position: new_position}) do
    piece = get_piece(game.board, current_position)

    new_board = game.board
    |> delete_piece(current_position)
    |> insert_piece(new_position, piece)

    %Game{game | board: new_board}
  end

  @default_deltas %{
               up: {1, 0},
             down: {-1, 0}, 
             left: {0, -1},
            right: {0, 1},
         up_right: {1, 1},
          up_left: {1, -1},
        down_left: {-1, -1},
       down_right: {-1, 1},
      el_up_right: {2, 1},
       el_up_left: {2, -1},
     el_down_left: {-2, -1},
    el_down_right: {-2, 1},
      el_right_up: {1, 2},
    el_right_down: {1, -2},
     el_left_down: {-1, -2},
       el_left_up: {-1, 2}
  }

  @spec surrounding_pieces(board, position) :: MapSet.t 
  def surrounding_pieces(board, piece_position) do 
    surrounding_pieces(board, piece_position, 1, @default_deltas)
  end

  @spec surrounding_pieces(board, position, integer, list) :: MapSet.t 
  defp surrounding_pieces(_, _, _, %{}), do: MapSet.new([])  
  defp surrounding_pieces(board, {row, col}, multiplier, deltas) do 
    bounds = %{min: 0, max: 7}

    result = deltas  
    |> Enum.map(fn {dir, {dy, dx}} -> {dir, {row * multiplier, col * multiplier}} end)
    |> Enum.filter(fn {_, {new_row, new_col}} -> new_row <= bounds.max && new_col >= bounds.min end)  
    |> Enum.map(fn {dir, {dy, dx}} -> {dir, board[dy][dx]} end) 
    |> Enum.split_with(fn {dir, piece} -> is_nil(piece) end) 
   
    [deltas_list | [pieces_list | _]] = result 

    remaining_deltas = Enum.into(deltas_list, %{})   
    pieces = Keyword.values(pieces_list) |> MapSet.new

    IO.puts pieces

    MapSet.union(pieces, surrounding_pieces(board, {row, col}, multiplier + 1, remaining_deltas))
  end

  @typep position :: tuple 
  @typep piece :: tuple 
  @typep board :: %{required(integer) => (nil | piece)}

  @spec populate_board(board) :: board
  defp populate_board(board) do
    white_pawn = {:white, :pawn}
    black_pawn = {:black, :pawn}

    board
    |> fill_row(1, white_pawn)
    |> fill_row(6, black_pawn)
    |> fill_back
  end

  @spec fill_back(board) :: board
  defp fill_back(board) do
    pieces = [
      {:rook, [0, 7]},
      {:knight, [1, 6]},
      {:bishop, [2, 5]},
      {:queen, [3]},
      {:king, [4]}
    ]

    Enum.reduce(pieces, board, fn ({piece, positions}, new_board) ->
      Enum.reduce(positions, new_board, fn (col, temp_board) ->
        with_white = put_in(temp_board[0][col], {:white, piece})
        put_in(with_white[7][col], {:black, piece})
      end)
    end)
  end

  @spec fill_row(board, integer, piece) :: board
  defp fill_row(board, row, piece) do
    cols = 0..7
    Enum.reduce(cols, board, fn col, new_board ->
      put_in(new_board, [row, col], piece)
    end)
  end

  @spec add_row(board, integer) :: map
  defp add_row(board, row_num) do
    row = initialize_row(%{}, 0)

    if row_num < 8 do
      Map.put(board, row_num, row) |> add_row(row_num + 1)
    else
      board
    end
  end

  @spec initialize_row(map, integer) :: map
  defp initialize_row(row, col_num) do
    if col_num < 8 do
      Map.put(row, col_num, nil) |> initialize_row(col_num + 1)
    else
      row
    end
  end

  @spec get_piece(board, position) :: (piece | nil)
  defp get_piece(board, {row, col}) do
    board[row][col]
  end

  @spec insert_piece(board, {integer, integer}, piece) :: board
  defp insert_piece(board, {row, col}, piece) do
    put_in(board[row][col], piece)
  end

  @spec delete_piece(board, {integer, integer}) :: board
  defp delete_piece(board, {row, col}) do
    put_in(board[row][col], nil)
  end
end
