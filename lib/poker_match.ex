defmodule PokerBot.PokerMatch do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__,[%{:hands => []}], name: :the_poker_match) #should setup match earlier
  end

  def new_card(card)do
    GenServer.cast(:the_poker_match, {:new_card, card})
  end



  #####################

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, _state) do
    {:reply, "BID", %{:last_move => "BID"}}
  end

  def handle_cast({:new_card, card}, state) do
    IO.puts "current state = #{inspect state}"
    newState = Map.put state, :current_card, card
    IO.puts "new state = #{inspect newState}"
    {:noreply, newState}
  end
end
