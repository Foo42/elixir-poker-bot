defmodule PokerBot.PokerMatch do
  use GenServer

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, _state) do
    {:reply, "BID", "BID"}
  end

  def handle_cast({:new_card, card}, state) do
    IO.puts "current state = #{inspect state}"
    newState = Map.put state, :current_card, card
    IO.puts "new state = #{inspect newState}"
    {:noreply, newState}
  end
end
