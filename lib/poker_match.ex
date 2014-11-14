defmodule PokerBot.PokerMatch do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__,[%{:hands => []}], name: :the_poker_match) #should setup match earlier
  end

  def new_card(card)do
    GenServer.cast(:the_poker_match, {:new_card, card})
  end

  def move() do
    GenServer.call(:the_poker_match, :move) 
  end

  defp begin_new_hand(state, card) do 
    new_hand = %{:card => card}
    Map.put state, :hands, [new_hand | state.hands]
  end



  #####################

  def init(_args) do
    {:ok, %{:hands => []}}
  end

  def handle_call(_msg, _from, _state) do
    {:reply, "BID", %{:last_move => "BID"}}
  end

  def handle_cast({:new_card, card}, state) do
    newState = begin_new_hand state, card
    {:noreply, newState}
  end

  def handle_call(:move, _from, _state) do
    "In handle call" |> IO.puts
    "BET"
  end
end
