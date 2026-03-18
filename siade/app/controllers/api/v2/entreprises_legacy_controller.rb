class API::V2::EntreprisesLegacyController < API::AuthenticateEntityController
  include INSEEDeprecation

  def show
    authorize :entreprises

    render deprecation_error(:entreprise)
  end
end
