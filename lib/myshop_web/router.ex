defmodule MyshopWeb.Router do
  use MyshopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    #    plug MyshopWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyshopWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/users", UserController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]

    resources "/products", ProductController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]

    resources "/categories", CategoryController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]

    resources "/orders", OrderController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]
  end

  scope "/manage", MyshopWeb do
    #    pipe_through [:browser, :authenticate_user]
    pipe_through [:browser]

    resources "/users", UserController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]

    resources "/products", ProductController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]

    resources "/categories", CategoryController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]

    resources "/orders", OrderController,
      only: [:index, :show, :new, :create, :edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyshopWeb do
  #   pipe_through :api
  # end
end
