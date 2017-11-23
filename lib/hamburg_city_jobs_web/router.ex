defmodule HamburgCityJobsWeb.Router do
  use HamburgCityJobsWeb, :router

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

  scope "/", HamburgCityJobsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", HamburgCityJobsWeb do
    pipe_through :api

    get "/search", SearchController, :index
  end
end
