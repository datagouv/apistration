return if Rails.env.production?

Seeds.new.perform
