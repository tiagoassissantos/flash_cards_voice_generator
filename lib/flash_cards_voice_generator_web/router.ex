defmodule FlashCardsVoiceGeneratorWeb.Router do
  use FlashCardsVoiceGeneratorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FlashCardsVoiceGeneratorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FlashCardsVoiceGeneratorWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/card_sets", CardSetLive.Index, :index
    live "/card_sets/new", CardSetLive.Index, :new
    live "/card_sets/:id/edit", CardSetLive.Index, :edit
    live "/card_sets/:id", CardSetLive.Show, :show
    live "/card_sets/:id/show/edit", CardSetLive.Show, :edit

    live "/cards", CardLive.Index, :index
    live "/cards/new", CardLive.Index, :new
    live "/cards/:id/edit", CardLive.Index, :edit
    live "/cards/:id", CardLive.Show, :show
    live "/cards/:id/show/edit", CardLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", FlashCardsVoiceGeneratorWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:flash_cards_voice_generator, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FlashCardsVoiceGeneratorWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
