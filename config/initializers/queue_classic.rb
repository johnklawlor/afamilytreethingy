ENV["DATABASE_URL"] = "postgres://vagrant:alalqo@localhost/mypeeps_development" if Rails.env.development?
#ENV["DATABASE_URL"] = "postgres://localhost/mypeeps_development" if Rails.env.development?