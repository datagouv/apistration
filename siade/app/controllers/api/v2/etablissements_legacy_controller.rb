class API::V2::EtablissementsLegacyController < API::V2::BaseController
  include INSEEDeprecation

  def show
    authorize :etablissements

    render deprecation_error(:etablissement)
  end
end
