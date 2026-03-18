class RenewINSEETokenService
  def call(force: false)
    @force = force || !file_exist?

    renew_insee_token
  end

  def current_token_expired?
    current_expiration_date <= Time.zone.now
  end

  def current_expiration_date
    Time.zone.at(
      YAML.load_file(filename)['expiration_date']
    )
  end

  private

  def renew_insee_token
    if @force || current_token_expired?
      write_token
      Rails.logger.info 'INSEE token renewed'
    end
  end

  def write_token
    File.write(filename, secrets.as_json.to_yaml)
  rescue StandardError
    Rails.logger.error "Failed to write new INSEE token (#{$ERROR_INFO.message})"
  end

  def secrets
    {
      token:           token_request.token,
      expiration_date: token_request.expiration_date,
      expires_in:      token_request.expires_in
    }
  end

  def token_request
    @request ||= SIADE::V3::Requests::INSEE::Token.new
  end

  def file_exist?
    File.exist?(filename)
  end

  def filename
    Rails.root.join('config', 'insee_secrets.yml')
  end
end
