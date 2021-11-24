class DGFIP::Authenticate::ValidateResponse < ValidateResponse
  def call
    return unless invalid_response?

    authenticate_error!
  end

  private

  def authenticate_error!
    fail_with_error!(build_error(::ProviderAuthenticationError))
  end

  def invalid_response?
    invalid_credentials? ||
      invalid_cookie?
  end

  def invalid_credentials?
    body.include?('Identifiant ou mot de passe erron')
  end

  def invalid_cookie?
    cookie !~ %r{^lemondgfip=.{65}; domain=.dgfip.finances.gouv.fr; path=/}
  end

  def cookie
    response['set-cookie']
  end
end
