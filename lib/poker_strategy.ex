defmodule PokerBot.Strategy do
  def choose_move(%{:card => %{:value => card_value}}) when card_value > 6 do
    {:bet, 1}
  end

  def choose_move(%{:card => %{:value => card_value}}) do
    {:fold}
  end
end
