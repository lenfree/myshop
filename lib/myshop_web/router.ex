defmodule MyshopWeb.Router do
  use MyshopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyshopWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/products", ProductController, only: [:index, :show]
  end

  scope "/manage", MyshopWeb do
    pipe_through :browser

    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyshopWeb do
  #   pipe_through :api
  # end
end
