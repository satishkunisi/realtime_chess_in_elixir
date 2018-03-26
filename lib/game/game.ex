defmodule RealtimeChess.Game do
  alias __MODULE__
  alias RealtimeChess.Game.GameState

  defstruct name: "", board: %{}, state: :unstarted #, player_white: %Player{}, player_black: %Player{}, board: %Board{} 
  @type t :: %__MODULE__{name: String.t, board: map, state: atom} 

  # @spec start(%{player_white: Player.t, player_black: Player.t}) :: Game.t
  # 
  # def start(player_white: %Player{}, player_black: %Player{}) do
  #   # generate a name
  #   # generate an empty board
  #   # create a process for holding game state
  #   # register the game
  #   # assign players to the game
  # end

  @spec random_string(number) :: String.t
  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end

