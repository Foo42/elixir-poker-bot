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
    # { :ok, pid } = GenServer.start_link(PokerBot.PokerMatch,[%{:hands => []}]) #should setup match earlier
    # GenServer.cast(pid, {:new_card, card})
    PokerBot.PokerMatch.new_card(card)
    text conn, "card = #{card}"
  end

  def update(conn, %{"COMMAND" => "OPPONENT_MOVE", "DATA" => move}) do
    text conn, "oppent move #{move}"
  end

  def start(conn, %{"OPPONENT_NAME" => opponent_name, "STARTING_CHIP_COUNT" => chips, "HAND_LIMIT" => hands}) do
    "in start" |> IO.puts
    {:ok, something} = PokerBot.PokerMatch.start()
    text conn, "starting"
  end

end
