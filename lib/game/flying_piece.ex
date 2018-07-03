defmodule RealtimeChess.Game.FlyingPiece do
  defmacro __using__(opts) do
    quote do
      import RealtimeChess.Game.FlyingPiece

      @spec attack_positions(tuple, atom, MapSet.t) :: MapSet.t
      def attack_positions(position, color, surrounding_pieces) do
        attack_positions(position, color, surrounding_pieces, unquote(opts)[:deltas])
      end

      @spec move_positions(tuple, atom, MapSet.t) :: MapSet.t
      def move_positions(position, color, surrounding_pieces) do
        move_positions(position, color, surrounding_pieces, unquote(opts)[:deltas])
      end
    end
  end

  @spec attack_positions(tuple, atom, MapSet.t, Map.t) :: MapSet.t
  def attack_positions(position, color, surrounding_pieces, deltas) do
    same_positions = same_color_positions(surrounding_pieces, color)
    opposing_positions = opposing_color_positions(surrounding_pieces, color)

    deltas
    |> Enum.map(fn {_, deltas} -> calculate_attacks(position, deltas, 1, same_positions, opposing_positions) end)
    |> List.flatten 
    |> MapSet.new
  end

  @spec move_positions(tuple, atom, MapSet.t, Map.t) :: MapSet.t
  def move_positions(position, _, surrounding_pieces, deltas) do
    surrounding_positions = get_all_positions(surrounding_pieces)

    deltas
    |> Enum.map(fn {_, deltas} -> calculate_positions(position, deltas, 1, surrounding_positions) end)
    |> List.flatten 
    |> MapSet.new
  end
  
  @spec calculate_positions(tuple, tuple, integer, MapSet.t) :: MapSet.t
  defp calculate_positions({row, col}, {dy, dx}, multiplier, surrounding_positions) do
    curr_position = {row + (dy * multiplier), col + (dx * multiplier)}
    if out_of_bounds?(curr_position) || MapSet.member?(surrounding_positions, curr_position) do 
      []
    else
      next_position = calculate_positions({row, col}, {dy, dx}, multiplier + 1, surrounding_positions)
      [curr_position] ++ [next_position] 
    end
  end

  @spec calculate_attacks(tuple, tuple, integer, MapSet.t, MapSet.t) :: MapSet.t
  defp calculate_attacks({row, col}, {dy, dx}, multiplier, same_positions, opposing_positions) do
    curr_position = {row + (dy * multiplier), col + (dx * multiplier)}
    cond do
      out_of_bounds?(curr_position) || MapSet.member?(same_positions, curr_position) -> 
        []
      MapSet.member?(opposing_positions, curr_position) ->
        [curr_position]
      true ->
        next_position = calculate_attacks({row, col}, {dy, dx}, multiplier + 1, same_positions, opposing_positions)
        [curr_position] ++ [next_position] 
    end
  end

  @spec get_all_positions(MapSet.t) :: MapSet.t
  defp get_all_positions(surrounding_pieces) do
    surrounding_pieces
    |> Enum.map(fn %{position: position, piece: _} -> position end)  
    |> MapSet.new
  end

  @spec opposing_color_positions(MapSet.t, atom) :: MapSet.t
  defp opposing_color_positions(surrounding_pieces, piece_color) do
    surrounding_pieces
    |> Enum.filter(fn %{position: _, piece: {color, _}} -> color != piece_color  end)
    |> Enum.map(fn %{position: position, piece: _} -> position end)  
    |> MapSet.new
  end
  
  @spec same_color_positions(MapSet.t, atom) :: MapSet.t
  defp same_color_positions(surrounding_pieces, piece_color) do
    surrounding_pieces
    |> Enum.filter(fn %{position: _, piece: {color, _}} -> color == piece_color  end)
    |> Enum.map(fn %{position: position, piece: _} -> position end)  
    |> MapSet.new
  end
  
  @spec out_of_bounds?(tuple) :: boolean 
  defp out_of_bounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row < bounds.min || row > bounds.max || col < bounds.min || col > bounds.max
  end
end
