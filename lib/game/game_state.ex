defmodule RealtimeChess.Game.GameState do
  alias RealtimeChess.Game
  alias RealtimeChess.Game.Board
  alias RealtimeChess.Game.Piece

  @typep board :: Board.t
  @typep position :: Piece.position()
  @typep pieces :: Piece.pieces()
  @typep board_piece :: Piece.board_piece()

  @spec initialize_board(Game.t) :: Game.t
  def initialize_board(game_state) do
    %Game{game_state | board: Board.populate_board()}
  end

  @spec update_name(Game.t, String.t) :: Game.t
  def update_name(%Game{} = game_state, new_name) do
    Map.put(game_state, :name, new_name)
  end

  @spec move_piece(Game.t, %{current_position: position, new_position: position}) :: Game.t
  def move_piece(%Game{} = game, %{current_position: _, new_position: _} = positions) do
    %Game{game | board: Board.move_piece(game.board, positions)}
  end

  @default_deltas %{
               up: {-1, 0},
             down: {1, 0},
             left: {0, -1},
            right: {0, 1},
         down_right: {1, 1},
          down_left: {1, -1},
        up_left: {-1, -1},
       up_right: {-1, 1},
      el_down_right: {2, 1},
       el_down_left: {2, -1},
     el_up_left: {-2, -1},
    el_up_right: {-2, 1},
      el_right_down: {1, 2},
    el_right_up: {1, -2},
     el_left_up: {-1, -2},
       el_left_down: {-1, 2}
  }

  @el_delta_keys [
   :el_down_right,
   :el_down_left,
   :el_up_left,
   :el_up_right,
   :el_right_down,
   :el_right_up,
   :el_left_up,
   :el_left_down
 ]

  @spec surrounding_pieces(board, position) :: pieces()
  def surrounding_pieces(board, piece_position) do
    surrounding_pieces(board, piece_position, 1, @default_deltas)
  end

  @spec surrounding_pieces(board, position, integer, map) :: pieces()
  defp surrounding_pieces(_, _, _, deltas) when deltas == %{}, do: MapSet.new([])
  defp surrounding_pieces(board, {row, col}, multiplier, deltas) do
    result = deltas
      |> Enum.map(fn {dir, {dy, dx}} -> {dir, {row + (dy * multiplier), col + (dx * multiplier)}} end)
      |> Enum.filter(fn {_, piece} -> inbounds?(piece) end)
      |> Enum.map(fn {dir, {new_row, new_col}} -> {dir, %{piece: board[new_row][new_col], position: {new_row, new_col}}} end)
      |> Enum.split_with(fn {_, %{piece: piece, position: _}} -> is_nil(piece) end)

    {deltas_list, pieces_list} = result

    without_el_deltas = Map.drop(@default_deltas, @el_delta_keys)
    remaining_deltas = Map.take(without_el_deltas, Keyword.keys(deltas_list))
    next_pieces = surrounding_pieces(board, {row, col}, multiplier + 1, remaining_deltas)

    current_pieces = Keyword.values(pieces_list) |> MapSet.new

    MapSet.union(
      current_pieces,
      next_pieces
    )
  end

  @spec valid_moves(board, board_piece) :: pieces()
  def valid_moves(board, %{piece: {color, piece_type}, position: position}) do
    with module_name <- :"Elixir.RealtimeChess.Game.#{piece_type |> Atom.to_string |> String.capitalize}",
         pieces <- surrounding_pieces(board, position)
    do
      MapSet.union(
        module_name.move_positions(position, color, pieces),
        module_name.attack_positions(position, color, pieces)
      )
    end
  end

  @spec inbounds?(position) :: boolean
  defp inbounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row >= bounds.min && row <= bounds.max && col >= bounds.min && col <= bounds.max
  end
end
