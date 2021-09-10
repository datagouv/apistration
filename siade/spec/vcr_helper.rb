# rubocop:disable Metrics/BlockLength
VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.ignore_localhost = true
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.configure_rspec_metadata!

  c.default_cassette_options = if ENV['regenerate_cassettes']
                                 # when regenerating cassettes it allows to add episodes with remote_storage at 'true' and THEN at 'false'
                                 { record: :new_episodes, allow_playback_repeats: true, match_requests_on: %i[method uri body headers] }
                               else
                                 # due to legacy we can't match on headers & body. But new ones will be ok
                                 { record: :none, allow_playback_repeats: true, match_requests_on: %i[method uri] }
                               end

  # VCR client's filters
  c.filter_sensitive_data('<INFOGREFFE_CODE_ABONNE>') { Siade.credentials[:infogreffe_code_abonne].to_s }
  c.filter_sensitive_data('<INFOGREFFE_MOT_PASSE>') { Siade.credentials[:infogreffe_mot_passe].to_s }
  c.filter_sensitive_data('<QUALIBAT_TOKEN>') { Siade.credentials[:qualibat_token].to_s }
  c.filter_sensitive_data('<FNTP_TOKEN>') { Siade.credentials[:fntp_token].to_s }
  c.filter_sensitive_data('<RGE_ADEME_TOKEN>') { Siade.credentials[:ademe_rge_token].to_s }
  c.filter_sensitive_data('<OPQIBI_TOKEN>') { Siade.credentials[:opqibi_token].to_s }
  c.filter_sensitive_data('<CNETP_TOKEN>') { Siade.credentials[:cnetp_token].to_s }
  c.filter_sensitive_data('<LOGIN_DGFIP>') { Siade.credentials[:dgfip_login].to_s }
  c.filter_sensitive_data('<SECRET_DGFIP>') { Siade.credentials[:dgfip_secret].to_s }
  c.filter_sensitive_data('<INSEE_TOKEN>') { (YAML.load_file(Rails.root.join('config', 'insee_secrets.yml'))[:token]).to_s }
  c.filter_sensitive_data('<INSEE_CREDENTIALIS>') { Siade.credentials[:insee_credentials].to_s }
  c.filter_sensitive_data('<INPI_LOGIN>') { Siade.credentials[:inpi_login].to_s }
  c.filter_sensitive_data('<INPI_PASSWORD>') { Siade.credentials[:inpi_password].to_s }
  c.filter_sensitive_data('<ACOSS_CLIENT_ID>') { Siade.credentials[:acoss_client_id].to_s }
  c.filter_sensitive_data('<ACOSS_CLIENT_SECRET>') { Siade.credentials[:acoss_client_secret].to_s }
  c.filter_sensitive_data('<SIADE_TOKEN>') { Siade.credentials[:uptime_robot_internal_jwt].to_s }
  c.filter_sensitive_data('<DOUANES_CLIENT_ID>') { Siade.credentials[:douanes_client_id].to_s }

  # VCR url filters
  c.filter_sensitive_data('<URL_INSEE_V3>') { Siade.credentials[:insee_v3_domain].to_s }
  c.filter_sensitive_data('<URL_GEO_API>') { Siade.credentials[:geo_api_domain].to_s }
  c.filter_sensitive_data('<URL_INPI>') { Siade.credentials[:inpi_url].to_s }
  c.filter_sensitive_data('<URL_ACOSS>') { Siade.credentials[:acoss_domain].to_s }
  c.filter_sensitive_data('<URL_DOUANES>') { Siade.credentials[:douanes_domain].to_s }

  c.filter_sensitive_data('<AUTH_DGFIP>') { Siade.credentials[:dgfip_authenticate_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_CA>') { Siade.credentials[:dgfip_chiffres_affaires_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_ATTESTATION>') { Siade.credentials[:dgfip_attestations_fiscales_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_LIASSE_DECLARATION>') { Siade.credentials[:dgfip_liasse_fiscale_declaration_url].to_s }
  c.filter_sensitive_data('<URL_DGFIP_LIASSE_DICO>') { Siade.credentials[:dgfip_liasse_fiscale_dictionnaire_url].to_s }

  c.filter_sensitive_data('<URL_QUALIBAT>') { Siade.credentials[:qualibat_url].to_s }

  c.register_request_matcher :headers_sanitized do |request_1, request_2|
    headers_to_ignore = %w[
      User-Agent
    ]

    request_1.headers.except(*headers_to_ignore) == request_2.headers.except(*headers_to_ignore)
  end
end
# rubocop:enable Metrics/BlockLength
