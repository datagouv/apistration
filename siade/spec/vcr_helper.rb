require 'xmlsimple'
require 'jwt'

VCR.configure do |c|
  c.before_record do |interaction|
    interaction.response.body.force_encoding('UTF-8')
  end
  c.preserve_exact_body_bytes do |http_message|
    !http_message.body.valid_encoding?
  end
  c.allow_http_connections_when_no_cassette = false
  c.ignore_localhost = true
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.configure_rspec_metadata!

  c.default_cassette_options = if ENV['regenerate_cassettes']
                                 # when regenerating cassettes it allows to add episodes with remote_storage at 'true' and THEN at 'false'
                                 { record: :new_episodes, allow_playback_repeats: true, match_requests_on: %i[method uri body_sanitized headers] }
                               else
                                 # due to legacy we can't match on headers & body. But new ones will be ok
                                 { record: :none, allow_playback_repeats: true, match_requests_on: %i[method uri] }
                               end

  # VCR client's filters
  c.filter_sensitive_data('<CIBTP_CLIENT_ID>') { Siade.credentials[:cibtp_client_id].to_s }
  c.filter_sensitive_data('<CIBTP_CLIENT_SECRET>') { Siade.credentials[:cibtp_client_secret].to_s }
  c.filter_sensitive_data('<INFOGREFFE_CODE_ABONNE>') { Siade.credentials[:infogreffe_code_abonne].to_s }
  c.filter_sensitive_data('<INFOGREFFE_MOT_PASSE>') { Siade.credentials[:infogreffe_mot_passe].to_s }
  c.filter_sensitive_data('<QUALIBAT_TOKEN>') { Siade.credentials[:qualibat_token].to_s }
  c.filter_sensitive_data('<FNTP_TOKEN>') { Siade.credentials[:fntp_token].to_s }
  c.filter_sensitive_data('<RGE_ADEME_TOKEN>') { Siade.credentials[:ademe_rge_token].to_s }
  c.filter_sensitive_data('<OPQIBI_TOKEN>') { Siade.credentials[:opqibi_token].to_s }
  c.filter_sensitive_data('<CNETP_TOKEN>') { Siade.credentials[:cnetp_token].to_s }
  c.filter_sensitive_data('<LOGIN_DGFIP>') { CGI.escape(Siade.credentials[:dgfip_login].to_s) }
  c.filter_sensitive_data('<SECRET_DGFIP>') { Siade.credentials[:dgfip_secret].to_s }
  c.filter_sensitive_data('<MDP_DGFIP>') { Siade.credentials[:dgfip_mdp].to_s }
  c.filter_sensitive_data('<USER_ID_DGFIP>') { valid_dgfip_user_id }
  c.filter_sensitive_data('<INSEE_TOKEN>') { 'valid insee token' }
  c.filter_sensitive_data('<ACOSS_CLIENT_ID>') { Siade.credentials[:acoss_client_id].to_s }
  c.filter_sensitive_data('<ACOSS_CLIENT_SECRET>') { Siade.credentials[:acoss_client_secret].to_s }
  c.filter_sensitive_data('<DOUANES_CLIENT_ID>') { Siade.credentials[:douanes_client_id].to_s }
  c.filter_sensitive_data('<MI_API_KEY>') { Siade.credentials[:mi_gravitee_api_key].to_s }
  c.filter_sensitive_data('<FRANCE_TRAVAIL_CLIENT_ID>') { Siade.credentials[:france_travail_client_id].to_s }
  c.filter_sensitive_data('<FRANCE_TRAVAIL_CLIENT_SECRET>') { Siade.credentials[:france_travail_client_secret].to_s }
  c.filter_sensitive_data('<FRANCE_TRAVAIL_AUTHENTICATE_URL>') { Siade.credentials[:france_travail_authenticate_url].to_s }
  c.filter_sensitive_data('<BANQUE_DE_FRANCE_BILANS_URL>') { Siade.credentials[:banque_de_france_bilans_url].to_s }
  c.filter_sensitive_data('<QUALIBAT_URL>') { URI(Siade.credentials[:qualibat_api_url]).to_s }
  c.filter_sensitive_data('<QUALIBAT_BASIC_AUTH>') { Base64.strict_encode64("#{Siade.credentials[:qualibat_api_username]}:#{Siade.credentials[:qualibat_api_password]}") }

  # VCR url filters
  c.filter_sensitive_data('<URL_CIBTP>') { Siade.credentials[:cibtp_domain].to_s }

  c.filter_sensitive_data('<URL_INSEE_V3>') { Siade.credentials[:insee_sirene_url].to_s }
  c.filter_sensitive_data('<URL_INSEE_AUTH>') { Siade.credentials[:insee_oauth_url].to_s }
  c.filter_sensitive_data('<URL_INSEE_METADATA_URL>') { Siade.credentials[:insee_metadata_url].to_s }
  c.filter_sensitive_data('<URL_GEO_API>') { Siade.credentials[:geo_api_domain].to_s }
  c.filter_sensitive_data('<URL_ACOSS>') { Siade.credentials[:acoss_domain].to_s }
  c.filter_sensitive_data('<URL_DOUANES>') { Siade.credentials[:douanes_domain].to_s }

  c.filter_sensitive_data('<AUTH_DGFIP>') { Siade.credentials[:dgfip_authenticate_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_CA>') { Siade.credentials[:dgfip_chiffres_affaires_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_ATTESTATION>') { Siade.credentials[:dgfip_attestations_fiscales_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_LIASSE_DECLARATION>') { Siade.credentials[:dgfip_liasse_fiscale_declaration_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_LIASSE_DICO>') { Siade.credentials[:dgfip_liasse_fiscale_dictionnaire_url].to_s }

  c.filter_sensitive_data('<URL_QUALIBAT>') { Siade.credentials[:qualibat_url].to_s }
  c.filter_sensitive_data('<URL_MI>') { Siade.credentials[:mi_domain].to_s }

  c.filter_sensitive_data('<CNOUS_AUTHENTICATE_URL>') { Siade.credentials[:cnous_authenticate_url].to_s }
  c.filter_sensitive_data('<RNM_DOMAIN>') { Siade.credentials[:rnm_domain].to_s }
  c.filter_sensitive_data('<ADEME_RGE_URL>') { Siade.credentials[:ademe_rge_url].to_s }
  c.filter_sensitive_data('<CNETP_DOMAIN>') { Siade.credentials[:cnetp_domain].to_s }
  c.filter_sensitive_data('<FNTP_DOMAIN>') { Siade.credentials[:fntp_domain].to_s }
  c.filter_sensitive_data('<INFOGREFFE_URL_EXTRAIT_RCS>') { Siade.credentials[:infogreffe_url_extrait_rcs].to_s }
  c.filter_sensitive_data('<PROBTP_DOMAIN>') { Siade.credentials[:probtp_domain].to_s }
  c.filter_sensitive_data('<OPQIBI_DOMAIN>') { Siade.credentials[:opqibi_domain].to_s }

  c.filter_sensitive_data('<CNOUS_CREDENTIALS>') { Siade.credentials[:cnous_authenticate_credentials].to_s }
  c.filter_sensitive_data('<MEN_SCOLARITES_URL>') { Siade.credentials[:men_scolarites_url_v1].to_s }
  c.filter_sensitive_data('<MEN_SCOLARITES_URL_V2>') { Siade.credentials[:men_scolarites_url_v2].to_s }
  c.filter_sensitive_data('<MEN_SCOLARITES_CLIENT_SECRET>') { Siade.credentials[:men_scolarites_client_secret].to_s }
  c.filter_sensitive_data('<MEN_SCOLARITES_AUTHENTICATE_URL>') { Siade.credentials[:men_scolarites_authenticate_url].to_s }

  c.filter_sensitive_data('<GIP_MDS_DOMAIN>') { Siade.credentials[:gip_mds_domain].to_s }
  c.filter_sensitive_data('<GIP_MDS_CLIENT_ID>') { Siade.credentials[:gip_mds_client_id].to_s }
  c.filter_sensitive_data('<GIP_MDS_CLIENT_SECRET>') { Siade.credentials[:gip_mds_client_secret].to_s }

  c.filter_sensitive_data('<CARIF_OREF_QUIFORME_URL>') { Siade.credentials[:carif_oref_quiforme_url].to_s }
  c.filter_sensitive_data('<CARIF_OREF_QUIFORME_TOKEN>') { Siade.credentials[:carif_oref_quiforme_token].to_s }

  c.filter_sensitive_data('<INPI_RNE_LOGIN_URL>') { Siade.credentials[:inpi_rne_login_url].to_s }
  c.filter_sensitive_data('<INPI_RNE_LOGIN_USERNAME>') { Siade.credentials[:inpi_rne_login_username].to_s }
  c.filter_sensitive_data('<INPI_RNE_LOGIN_PASSWORD>') { Siade.credentials[:inpi_rne_login_password].to_s }
  c.filter_sensitive_data('<INPI_RNE_URL>') { Siade.credentials[:inpi_rne_url].to_s }

  c.filter_sensitive_data('<EUROPEAN_COMMISSION_VIES_URL>') { Siade.credentials[:european_commission_vies_url].to_s }
  c.filter_sensitive_data('<FABRIQUE_NUMERIQUE_CONVENTIONS_COLLECTIVES_URL>') { Siade.credentials[:fabrique_numerique_conventions_collectives_url].to_s }
  c.filter_sensitive_data('<MSA_CONFORMITES_COTISATIONS_URL>') { Siade.credentials[:msa_conformites_cotisations_url].to_s }

  c.register_request_matcher :body_sanitized do |r_1, r_2|
    body_1 = r_1.body || ''
    body_2 = r_2.body || ''

    (body_1 == body_2) ||
      (body_1.squeeze(' ') == body_2.squeeze(' ')) ||
      (XmlSimple.xml_in(body_1) == XmlSimple.xml_in(body_2))
  rescue ArgumentError
    false
  end

  c.register_request_matcher :headers_sanitized do |request, registered_request|
    headers_to_ignore = %w[
      User-Agent
      X-Correlation-Id
    ]

    bool = request.headers.except(*headers_to_ignore) == registered_request.headers.except(*headers_to_ignore)

    if ENV.fetch('DEBUG_VCR', false) && !bool
      print "Diff on headers:\n"
      mismatching_keys = (request.headers.except(*headers_to_ignore).to_a - registered_request.headers.except(*headers_to_ignore).to_a).pluck(0)
      mismatching_keys += (registered_request.headers.except(*headers_to_ignore).to_a - request.headers.except(*headers_to_ignore).to_a).pluck(0)
      mismatching_keys.uniq!

      mismatching_keys.each do |key|
        print "* '#{key}'\n"
        print "  Current:    #{request.headers[key] || 'EMPTY VALUE'}\n"
        print "  Registered: #{registered_request.headers[key] || 'EMPTY VALUE'}\n"
      end

      print "================\n"
    end

    bool
  end

  c.debug_logger = $stdout if ENV['DEBUG_VCR']
end

RSpec.configure do |config|
  config.around do |example|
    if example.metadata[:disable_vcr]
      VCR.turned_off(&example)
    else
      example.run
    end
  end
end
