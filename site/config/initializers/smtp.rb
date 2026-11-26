ActiveSupport.on_load(:action_mailer) do
  next unless Rails.env.production? || Rails.env.staging? || Rails.env.sandbox?

  self.delivery_method = :smtp
  self.smtp_settings = {
    address: 'smtp-relay.brevo.com',
    port: 587,
    user_name: AdminApientreprise.credentials[:brevo_smtp_login],
    password: AdminApientreprise.credentials[:brevo_smtp_key],
    authentication: :login,
    enable_starttls: true
  }
end
