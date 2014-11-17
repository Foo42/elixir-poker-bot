defmodule PokerBot.PokerMatch do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__,[], name: :the_poker_match)
  end

  def new_card(card) when is_binary(card) do
    new_card(%{:card => card, :value => evaluate_card(card)})
  end

  def new_card(card)do 
    GenServer.cast(:the_poker_match, {:new_card, card})
  end

  defp evaluate_card(card) do
    index = ~w(2 3 4 5 6 7 8 9 T J Q K A) |> Enum.find_index &(&1 == card)
    index + 1
  end

  def move() do
    GenServer.call(:the_poker_match, :move) 
  end

  defp begin_new_hand(state, card) do 
    new_hand = %{:card => card}
    IO.puts "in begin new hand, state = #{inspect state}"
    Map.put state, :hands, [new_hand | state.hands]
  end



  #####################

  def init(_args) do
    {:ok, %{:hands => []}}
  end

  def handle_call(:move, _from, state = %{:hands => [%{:card => %{:value => card_value}}|_tail]}) when card_value > 6 do
    "In handle call" |> IO.puts
    {:reply, "BET", state}
  end

  def handle_call(:move, _from, state) do
    new_state = state |> Map.put :last_move, "BID"
    {:reply, "FOLD",  new_state}
  end

  def handle_call(_msg, _from, state) do
    "In handle call" |> IO.puts
    {:reply, "not handled yet", state}
  end

  def handle_cast({:new_card, card}, state) do
    newState = begin_new_hand state, card
    {:noreply, newState}
  end
  
end
