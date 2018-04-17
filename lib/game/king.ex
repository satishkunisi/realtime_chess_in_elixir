defmodule RealtimeChess.Game.King do
  @spec move_positions(tuple, atom) :: MapSet.t
  def move_positions({row, col}, _) do
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
  end

  @spec move_positions(tuple, atom) :: MapSet.t
  def attack_positions({row, col}, _) do
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
  end
end
