defmodule FakebustersWeb.Router do
  use FakebustersWeb, :router

  import FakebustersWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :put_root_layout, {FakebustersWeb.LayoutView, :root}
    plug :put_layout, {FakebustersWeb.LayoutView, "regular_nav.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Public routes

  scope "/", FakebustersWeb do
    pipe_through [:browser]

    get "/", PageController, :index
  end

  ## Secured routes

  scope "/", FakebustersWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/dashboard", DashboardController, :index
    get "/investigations/:id", BoardController, :index
  end

  ## Authentication routes

  scope "/", FakebustersWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", FakebustersWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", FakebustersWeb do
    pipe_through [:browser]

    get "/users/log_out", UserSessionController, :delete
    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  ## Dev routes

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/monitoring", metrics: FakebustersWeb.Telemetry
    end
  end
end
