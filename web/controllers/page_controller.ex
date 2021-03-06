defmodule PokerBot.PageController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    render conn, "index"
  end

  def not_found(conn, _params) do
    render conn, "not_found"
  end

  def error(conn, _params) do
    render conn, "error"
  end

  def update(conn, %{"COMMAND" => "CARD", "DATA" => card}) do
    PokerBot.PokerMatch.new_card(card)
    text conn, "card = #{card}"
  end

  def update(conn, %{"COMMAND" => "RECEIVE_CHIPS", "DATA" => chips}) do
    {value, _remainder} = chips |> Integer.parse
    PokerBot.PokerMatch.recieve_chips(value)
    text conn, "recieved #{value} chips"
  end

  def update(conn, %{"COMMAND" => "OPPONENT_MOVE", "DATA" => move}) do
    move |> parse_opponent_move |> PokerBot.PokerMatch.opponent_move
    text conn, "oppent move #{move}"
  end

  def update(conn, %{"COMMAND" => "POST_BLIND"}) do
    PokerBot.PokerMatch.post_blind
    text conn, "OK"
  end

  def update(conn, params) do
    IO.puts "in unhandled update #{inspect params}"
    text conn, "OK"
  end

  def start(conn, %{"HAND_LIMIT" => hand_limit, "OPPONENT_NAME" => opponent_name, "STARTING_CHIP_COUNT" => starting_chips}) do
    "in start" |> IO.puts
    {hand_limit_num, _} = Integer.parse hand_limit
    {starting_chips_num, _} = Integer.parse starting_chips
    match_params = %{:hand_limit => hand_limit_num, :opponent_name => opponent_name, :starting_chips => starting_chips_num}
    {:ok, match} = PokerBot.PokerMatch.start(match_params);
    text conn, "starting"
  end

  def move(conn, _params) do
    "in move" |> IO.puts
    text conn, PokerBot.PokerMatch.move()
  end

  defp parse_opponent_move(move) do

    cond do
      {"amount" => amount} = Regex.named_captures ~r/BET:(?<amount>\d+)/, move ->
        {:bet, amount |> parse_int)}
      "BET" = move ->
        {:bet, 1}
      true ->
        {:unknown_move, move}
      end
  end

  defp parse_int(s) do
    {num, ""} = Integer.parse(s)
    num
  end

end
