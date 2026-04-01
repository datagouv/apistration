Lockbox.master_key = Rails.env.local? ? ('0' * 64) : Siade.credentials.fetch(:lockbox_master_key)
