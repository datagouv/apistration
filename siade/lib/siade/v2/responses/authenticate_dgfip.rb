class SIADE::V2::Responses::AuthenticateDGFIP < SIADE::V2::Responses::Generic
  def cookie
    @raw_response['set-cookie']
  end

  protected

  def provider_name
    'DGFIP'
  end

  def adapt_raw_response_code
    if authentication_failed
      set_error_message_for(502)
    else
      @raw_response.code.to_i
    end
  end

  private

  def authentication_failed
    is_error = false
    is_error ||= @body.include?('Identifiant ou mot de passe erron') unless @body.nil?
    is_error ||= !(cookie =~ %r{^lemondgfip=.{65}; domain=.dgfip.finances.gouv.fr; path=/})
  end

  def set_error_message_502
    errors << ProviderAuthenticationError.new(provider_name)
  end
end
