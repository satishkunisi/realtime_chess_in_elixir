defmodule RealtimeChess.Game.Queen do 
  @deltas %{
           up: {-1, 0},
         down: {1, 0}, 
         left: {0, -1},
        right: {0, 1},
   down_right: {1, 1},
    down_left: {1, -1},
      up_left: {-1, -1},
     up_right: {-1, 1}
  }

  @spec attack_positions(tuple, atom) :: MapSet.t
  def attack_positions(position, color) do
    move_positions(position, color) 
  end

  @spec move_positions(tuple, atom) :: MapSet.t
  def move_positions(position, _) do
    @deltas
    |> Enum.map(fn {_, deltas} -> calculate_positions(position, deltas, 1) end)
    |> List.flatten 
    |> MapSet.new
  end
  
  @spec calculate_positions(tuple, tuple, integer) :: MapSet.t
  defp calculate_positions({row, col}, {dy, dx}, multiplier) do
    curr_position = {row + (dy * multiplier), col + (dx * multiplier)}
    if inbounds?(curr_position) do 
      next_position = calculate_positions({row, col}, {dy, dx}, multiplier + 1)
      [curr_position] ++ [next_position] 
    else
      []
    end
  end

  @spec inbounds?(tuple) :: boolean 
  defp inbounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row >= bounds.min && row <= bounds.max && col >= bounds.min && col <= bounds.max
  end
end
