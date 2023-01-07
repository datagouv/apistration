class APIEntreprise::V2::DocumentsINPIController < APIEntreprise::V2::BaseController
  private

  def siren
    params.require(:siren)
  end

  def cookie
    @cookie ||= SIADE::V2::Requests::INPI::Authenticate.new.cookie
  end

  def process_through_authentication
    if cookie.nil?
      error = ProviderAuthenticationError.new('INPI')

      render error_json(error, status: 502)
    else
      yield
    end
  end
end
