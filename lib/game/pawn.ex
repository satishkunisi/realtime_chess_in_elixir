defmodule RealtimeChess.Game.Pawn do
  @bounds %{row_min: 0, col_min: 0, row_max: 7, col_max: 7}
  @starting_row %{white: 1, black: 6}

  @spec move_positions(tuple, :white) :: MapSet.t
  def move_positions({row, col}, :white) do
    # map over all motions and calculate all positions from current position
    white_motions(row)
    |> calculate_positions({row, col})
  end

  @spec move_positions(tuple, :black) :: MapSet.t
  def move_positions({row, col}, :black) do
    # map over all motions and calculate all positions from current position
    black_motions(row)
    |> calculate_positions({row, col})
  end

  @spec attack_positions(tuple, :black) :: MapSet.t
  def attack_positions({row, col}, :black) do
    MapSet.new([{row - 1, col + 1}, {row - 1, col - 1}])
  end

  @spec attack_positions(tuple, :white) :: MapSet.t
  def attack_positions({row, col}, :white) do
    MapSet.new([{row + 1, col + 1}, {row + 1, col - 1}])
  end


  @spec calculate_positions(list, tuple) :: MapSet.t
  defp calculate_positions(motions, {row, col}) do
    motions
    |> Enum.map(fn {dx, dy} -> {row + dx, col + dy} end)
    |> MapSet.new
  end

  @spec white_motions(integer) :: list(tuple)
  defp white_motions(row) do
    if row == @starting_row.white do
      [{1, 0}, {2, 0}]
    else
      [{1, 0}]
    end
  end

  @spec black_motions(integer) :: list(tuple)
  defp black_motions(row) do
    if row == @starting_row.black do
      [{-1, 0}, {-2, 0}]
    else
      [{-1, 0}]
    end
  end
end
