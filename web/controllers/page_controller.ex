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

  def update(conn, %{"COMMAND" => "OPPONENT_MOVE", "DATA" => move}) do
    text conn, "oppent move #{move}"
  end

  def update(conn, params) do
    IO.puts "in unhandled update #{inspect params}"
    text conn, "OK"
  end

  def start(conn, %{"OPPONENT_NAME" => opponent_name, "STARTING_CHIP_COUNT" => chips, "HAND_LIMIT" => hands}) do
    "in start" |> IO.puts
    {:ok, something} = PokerBot.PokerMatch.start()
    text conn, "starting"
  end

  def move(conn, _params) do
    "in move" |> IO.puts
    text conn, PokerBot.PokerMatch.move()
  end
end
