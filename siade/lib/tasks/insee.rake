namespace :insee do
  desc 'Renew INSEE token for 36h (config on website)'
  task renew_token: :environment do
    service = RenewINSEETokenService.new
    service.call(force: true)
    total_seconds = service.current_expiration_date - Time.zone.now
    expires_in = Time.at(total_seconds).utc.strftime('%d days %H:%M:%S')
    puts "Expires in: #{expires_in} (#{service.current_expiration_date})"
  end
end
