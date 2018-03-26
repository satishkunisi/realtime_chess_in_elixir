defmodule RealtimeChess.Game.Registry do
  use GenServer
  
  @spec start_link(list(atom)) :: any
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @spec lookup(pid, String.t) :: tuple | atom 
  def lookup(server, name) do 
    GenServer.call(server, {:lookup, name})
  end

  @spec create(server :: pid, game :: pid, name :: String.t) :: tuple | atom 
  def create(server, game, name) do 
    GenServer.call(server, {:create, game, name})
  end

  ## Server callbacks

  @spec init(:ok) :: {:ok, %{}} 
  def init(:ok) do
    {:ok, %{}}
  end

  @type call_response :: {:reply, struct, map}

  @spec handle_call(tuple, GenServer.from, map) :: call_response 
  def handle_call(payload, _from, names) do
    case payload do
      {:lookup, name} -> 
        {:reply, Map.fetch(names, name), names}
      {:create, game, name} ->  
        if Map.has_key?(names, name) do
          {:reply, Map.fetch(names, name), names}
        else
          new_names = Map.put(names, name, game)
          {:reply, game, new_names} 
        end
    end
  end
end
