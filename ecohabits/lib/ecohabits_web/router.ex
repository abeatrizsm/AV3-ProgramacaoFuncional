defmodule EcohabitsWeb.Router do
  use EcohabitsWeb, :router

  import EcohabitsWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {EcohabitsWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_scope_for_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", EcohabitsWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
  end

  if Application.compile_env(:ecohabits, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: EcohabitsWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  scope "/", EcohabitsWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{EcohabitsWeb.UserAuth, :require_authenticated}] do
      live("/users/settings", UserLive.Settings, :edit)
      live("/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email)
      live("/profile", UserLive.Profile, :show)
      live("/dashboard", DashboardLive.Dashboard, :show)
    end

    post("/users/update-password", UserSessionController, :update_password)
  end

  scope "/", EcohabitsWeb do
    pipe_through([:browser])

    live_session :current_user,
      on_mount: [{EcohabitsWeb.UserAuth, :mount_current_scope}] do
      live("/users/register", UserLive.Registration, :new)
      live("/users/log-in", UserLive.Login, :new)
      live("/users/log-in/:token", UserLive.Confirmation, :new)
    end

    post("/users/log-in", UserSessionController, :create)
    delete("/users/log-out", UserSessionController, :delete)
  end
end
