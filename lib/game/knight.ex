defmodule RealtimeChess.Game.Knight do 
  @bounds %{row_min: 0, col_min: 0, row_max: 7, col_max: 7} 

  @spec move_positions(tuple, atom) :: MapSet.t
  def move_positions({row, col}, _) do
    deltas = [{1, 2}, {1, -2}, {-1, -2}, {-1, 2}, {2, 1}, {2, -1}, {-2, -1}, {-2, 1}]

    deltas
    |> Enum.map(fn {dy, dx} -> {row + dy, col + dx} end)  
    |> MapSet.new
  end
end
