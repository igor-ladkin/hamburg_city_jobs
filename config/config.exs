# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hamburg_city_jobs,
  ecto_repos: [HamburgCityJobs.Repo]

# Configures the endpoint
config :hamburg_city_jobs, HamburgCityJobsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J3764KOMcvOIvemgVkZjy/yBAi3hcmouHKrWMNvA1FXlIwyCA/d04HfBx/w+bN1E",
  render_errors: [view: HamburgCityJobsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HamburgCityJobs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
