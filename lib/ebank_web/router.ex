defmodule EbankWeb.Router do
  use EbankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EbankWeb do
    pipe_through :api

    get "/reset", ResetFileController, :index
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: EbankWeb.Telemetry
    end
  end
end
