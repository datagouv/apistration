class API::V2::Etablissements::PredecesseurController < API::AuthenticateEntityController
  include INSEEDeprecation

  def show
    authorize :etablissements

    render deprecation_error(:etablissement)
  end
end
