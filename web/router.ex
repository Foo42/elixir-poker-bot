defmodule PokerBot.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", PokerBot.PageController, :index, as: :pages
    post "/update", PokerBot.PageController, :update, as: :pages
    post "/start", PokerBot.PageController, :start, as: :pages
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
