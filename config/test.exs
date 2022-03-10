import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ebank, EbankWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "VpoP6JWNsR9g2cyyIcoOi77gISrGsIQSEGkQdckqrFRseZzF0Bm0EWTg4OVQw7VN",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
