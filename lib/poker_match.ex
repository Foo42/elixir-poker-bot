defmodule PokerBot.PokerMatch do
  use GenServer

  def start(match_parameters) do
    GenServer.start_link(__MODULE__,[match_parameters], name: :the_poker_match)
  end

  def new_card(card) when is_binary(card) do
    new_card(%{:card => card, :value => evaluate_card(card)})
  end

  def new_card(card)do 
    GenServer.cast(:the_poker_match, {:new_card, card})
  end

  def recieve_chips(chips) do
    GenServer.cast :the_poker_match, {:recieve_chips, chips}
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

  def init(args) do
    "initiaising with args = #{inspect Enum.at(args, 0)}" |> IO.puts
    [match_parameters | _t] = args;

    {:ok, %{:hands => [], :opponent_name => match_parameters.opponent_name, :chips => match_parameters.starting_chips, :hand_limit => match_parameters.hand_limit}}
  end

  def handle_call(:move, _from, state) do
    "In handle call" |> IO.puts
    [hand|_previous_hands] = state.hands
    move = PokerBot.Strategy.choose_move hand
    {return_string, new_state} = make_move move, state
    {:reply, return_string, new_state}
  end

  def handle_call(_msg, _from, state) do
    "In handle call" |> IO.puts
    {:reply, "not handled yet", state}
  end

  def handle_cast({:new_card, card}, state) do
    newState = begin_new_hand state, card
    {:noreply, newState}
  end

  def handle_cast({:recieve_chips, chips}, state) do
    total_chips = state.chips + chips
    new_state = state |> Map.put :chips, total_chips
    "Now with #{total_chips} chips!" |> IO.puts
    {:noreply, new_state}
  end

  def make_move({:bet, amount}, state) do
    total_chips = state.chips - amount
    new_state = state |> Map.put :chips, total_chips
    {"BET:#{amount}", new_state}
  end

  def make_move({:fold}, state) do
    {"FOLD", state}
  end
  
end
