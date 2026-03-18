# :nocov:
unless %w[development test].include?(Rails.env)
  puts 'Renewing INSEE token'
  RenewINSEETokenService.new.call(force: true)
end
# :nocov:
