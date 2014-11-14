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
    { :ok, pid } = GenServer.start_link(PokerBot.PokerMatch,[%{:hands => []}]) #should setup match earlier
    GenServer.cast(pid, {:new_card, card})
    text conn, "got card #{card} and match pid = #{inspect pid}"
  end

  def update(conn, %{"COMMAND" => "OPPONENT_MOVE", "DATA" => move}) do
    text conn, "oppent move #{move}"
  end

end
