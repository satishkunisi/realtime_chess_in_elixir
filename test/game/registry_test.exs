defmodule RealtimeChess.Game.RegistryTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Registry

  setup do
    {:ok, registry} = start_supervised(Registry)
    %{registry: registry}
  end
  
  test "spawns game states", %{registry: registry} do  
    assert Registry.lookup(registry, "testname") == :error 

    {:ok, game} = Agent.start_link(fn -> [] end)
    Registry.create(registry, game, "testname")  

    assert {:ok, game} = Registry.lookup(registry, "testname")
  end
end
