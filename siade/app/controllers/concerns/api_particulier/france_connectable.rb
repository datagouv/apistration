module APIParticulier::FranceConnectable
  extend ActiveSupport::Concern

  attr_reader :france_connect_service_user_identity, :france_connect_client_attributes

  included do
    before_action :verify_recipient_is_a_siret!, if: :france_connect?
  end

  def france_connect_organizer
    @france_connect_organizer ||= FranceConnect::DataFetcherThroughAccessToken.call(
      params: { token: bearer_token_from_headers, api_name:, api_version: }
    )
  end

  # rubocop:disable Metrics/AbcSize
  def civility_parameters_from_france_connect(except: [])
    {
      nom_usage: france_connect_service_user_identity.preferred_username,
      nom_naissance: france_connect_service_user_identity.family_name,
      prenoms: france_connect_service_user_identity.given_name.split,
      annee_date_naissance: france_connect_service_user_identity.birthdate.split('-').first,
      mois_date_naissance: france_connect_service_user_identity.birthdate.split('-').second,
      jour_date_naissance: france_connect_service_user_identity.birthdate.split('-').third,
      code_cog_insee_commune_naissance: france_connect_service_user_identity.birthplace,
      code_cog_insee_pays_naissance: france_connect_service_user_identity.birthcountry,
      sexe_etat_civil: france_connect_service_user_identity.gender == 'male' ? 'M' : 'F',
      france_connect: true
    }.except(*except)
  end
  # rubocop:enable Metrics/AbcSize

  protected

  def authenticate_user!
    if bearer_token_from_headers
      handle_france_connect_flow
    else
      super
    end
  end

  private

  def handle_france_connect_flow
    if france_connect_organizer.success?
      @france_connect_service_user_identity = france_connect_organizer.service_user_identity
      @france_connect_client_attributes = france_connect_organizer.client_attributes
      @current_user = france_connect_organizer.user
    else
      render_errors(france_connect_organizer)
      false
    end
  end

  def france_connect?
    france_connect_service_user_identity.present?
  end

  def api_name
    self.class.name.split('::').last.gsub('Controller', '').underscore.gsub('_with_france_connect', '')
  end
end
