# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
SECRET_TOKEN = YAML.load_file("#{::Rails.root}/config/secret_token.yml")[::Rails.env] if Rails.env.development?

Mypeeps::Application.config.secret_key_base = ENV['SECRET_TOKEN'] || SECRET_TOKEN["secret_token"]