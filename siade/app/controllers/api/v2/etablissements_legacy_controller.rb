class API::V2::EtablissementsLegacyController < API::AuthenticateEntityController
  include INSEEDeprecation

  def show
    authorize :etablissements

    render deprecation_error(:etablissement)
  end
end
