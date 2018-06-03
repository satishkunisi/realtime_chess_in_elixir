defmodule RealtimeChess.Game.King do
  @spec move_positions(tuple, atom, MapSet.t) :: MapSet.t
  def move_positions({row, col}, _, surrounding_pieces) do
    [{row + 1, col},
     {row - 1, col},
     {row, col + 1},
     {row + 1, col + 1},
     {row - 1, col + 1},
     {row, col - 1},
     {row + 1, col - 1},
     {row - 1, col - 1}]
    |> circumscribe_moves(surrounding_pieces)
    |> MapSet.new
  end

  @spec attack_positions(tuple, atom, MapSet.t) :: MapSet.t
  def attack_positions({row, col}, color, surrounding_pieces) do
    MapSet.new([
      {row + 1, col},
      {row - 1, col},
      {row, col + 1},
      {row + 1, col + 1},
      {row - 1, col + 1},
      {row, col - 1},
      {row + 1, col - 1},
      {row - 1, col - 1}
    ])
    |> circumscribe_attacks(surrounding_pieces, color)
    |> MapSet.new
  end

  @spec circumscribe_moves(MapSet.t, MapSet.t) :: MapSet.t
  defp circumscribe_moves(possible_positions, surrounding_pieces) do
    surrounding_positions = get_positions(surrounding_pieces) 

    possible_positions
    |> Enum.filter(&inbounds?/1)
    |> MapSet.new
    |> MapSet.difference(surrounding_positions)
  end

  @spec circumscribe_attacks(MapSet.t, MapSet.t, atom) :: MapSet.t
  defp circumscribe_attacks(possible_attacks, surrounding_pieces, piece_color) do
    surrounding_positions = surrounding_pieces
    |> Enum.filter(fn %{position: _, piece: {color, _}} -> color == piece_color end)
    |> get_positions

    possible_attacks
    |> Enum.filter(&inbounds?/1)
    |> MapSet.new
    |> MapSet.difference(surrounding_positions)
  end

  @spec get_positions(MapSet.t) :: MapSet.t
  defp get_positions(surrounding_pieces) do
    surrounding_pieces
    |> Enum.map(fn %{position: position, piece: _} -> position end)  
    |> MapSet.new
  end

  @spec inbounds?(tuple) :: boolean 
  defp inbounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row >= bounds.min && row <= bounds.max && col >= bounds.min && col <= bounds.max
  end
end
