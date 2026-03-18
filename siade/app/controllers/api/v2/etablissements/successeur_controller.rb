class API::V2::Etablissements::SuccesseurController < API::AuthenticateEntityController
  include INSEEDeprecation

  def show
    authorize :etablissements

    render deprecation_error(:etablissement)
  end
end
