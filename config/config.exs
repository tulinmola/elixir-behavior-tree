use Mix.Config

config :behavior, Behavior.Parser, base_modules: []

import_config "#{Mix.env()}.exs"
