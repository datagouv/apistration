namespace :insee do
  desc 'Hand the INSEE account back to the derived password, from the bypass one'
  task rotate_from_bypass: :environment do
    bypass_password = INSEE::PasswordDerivation.bypass_password
    current_password = INSEE::PasswordDerivation.current_password
    authentication = INSEEAPIAuthentication.new

    attempt = authentication.attempt(bypass_password)

    if attempt.status == :granted
      response = INSEEPasswordRenewal.new.renew(
        token: attempt.token,
        old_password: bypass_password,
        new_password: current_password
      )

      abort("INSEE rejected the renewal (HTTP #{response.status}): #{response.body}") unless response.status == 200

      puts 'INSEE now holds the derived password: remove the bypass credentials and deploy'
    else
      abort('INSEE authenticates with neither the bypass nor the derived password') unless authentication.attempt(current_password).status == :granted

      puts 'INSEE already holds the derived password, nothing to renew'
    end
  end
end
