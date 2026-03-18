VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.ignore_localhost = true
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.configure_rspec_metadata!

  unless ENV['regenerate_cassettes']
    # due to legacy we can't match on headers & body. But new ones will be ok
    c.default_cassette_options = { record: :none, allow_playback_repeats: true, match_requests_on: %i[method uri] }
  else
    # when regenerating cassettes it allows to add episodes with remote_storage at 'true' and THEN at 'false'
    c.default_cassette_options = { record: :new_episodes, allow_playback_repeats: true, match_requests_on: %i[method uri body headers] }
  end

  # VCR client's filters
  c.filter_sensitive_data('<INFOGREFFE_CODE_ABONNE>' ) { "#{Siade.credentials[:infogreffe_code_abonne]}" }
  c.filter_sensitive_data('<INFOGREFFE_MOT_PASSE>'   ) { "#{Siade.credentials[:infogreffe_mot_passe]}" }
  c.filter_sensitive_data('<QUALIBAT_TOKEN>'         ) { "#{Siade.credentials[:qualibat_token]}" }
  c.filter_sensitive_data('<FNTP_TOKEN>'             ) { "#{Siade.credentials[:fntp_token]}" }
  c.filter_sensitive_data('<RGE_ADEME_TOKEN>'        ) { "#{Siade.credentials[:ademe_rge_token]}" }
  c.filter_sensitive_data('<OPQIBI_TOKEN>'           ) { "#{Siade.credentials[:opqibi_token]}" }
  c.filter_sensitive_data('<CNETP_TOKEN>'            ) { "#{Siade.credentials[:cnetp_token]}" }
  c.filter_sensitive_data('<LOGIN_DGFIP>'            ) { "#{Siade.credentials[:dgfip_login]}" }
  c.filter_sensitive_data('<SECRET_DGFIP>'           ) { "#{Siade.credentials[:dgfip_secret]}" }
  c.filter_sensitive_data('<INSEE_TOKEN>'            ) { "#{YAML.load_file(Rails.root.join('config', 'insee_secrets.yml'))[:token]}" }
  c.filter_sensitive_data('<INSEE_CREDENTIALIS>'     ) { "#{Siade.credentials[:insee_credentials]}" }
  c.filter_sensitive_data('<INPI_LOGIN>'             ) { "#{Siade.credentials[:inpi_login]}" }
  c.filter_sensitive_data('<INPI_PASSWORD>'          ) { "#{Siade.credentials[:inpi_password]}" }
  c.filter_sensitive_data('<ACOSS_CLIENT_ID>'        ) { "#{Siade.credentials[:acoss_client_id]}" }
  c.filter_sensitive_data('<ACOSS_CLIENT_SECRET>'    ) { "#{Siade.credentials[:acoss_client_secret]}" }
  c.filter_sensitive_data('<SIADE_TOKEN>'            ) { "#{Siade.credentials[:uptime_robot_internal_jwt]}" }
  c.filter_sensitive_data('<DOUANES_CLIENT_ID>'      ) { "#{Siade.credentials[:douanes_client_id]}" }

  # VCR url filters
  c.filter_sensitive_data('<URL_INSEE_V3>') { "#{Siade.credentials[:insee_v3_domain]}" }
  c.filter_sensitive_data('<URL_GEO_API>' ) { "#{Siade.credentials[:geo_api_domain]}" }
  c.filter_sensitive_data('<URL_INPI>'    ) { "#{Siade.credentials[:inpi_url]}" }
  c.filter_sensitive_data('<URL_ACOSS>'   ) { "#{Siade.credentials[:acoss_domain]}" }
  c.filter_sensitive_data('<URL_DOUANES>' ) { "#{Siade.credentials[:douanes_domain]}" }

  c.filter_sensitive_data('<AUTH_DGFIP>'                  ) { "#{Siade.credentials[:dgfip_authenticate_url]}" }
  c.filter_sensitive_data('<URL_DGFIP_CA>'                ) { "#{Siade.credentials[:dgfip_chiffres_affaires_url]}" }
  c.filter_sensitive_data('<URL_DGFIP_ATTESTATION>'       ) { "#{Siade.credentials[:dgfip_attestations_fiscales_url]}" }
  c.filter_sensitive_data('<URL_DGFIP_LIASSE_DECLARATION>') { "#{Siade.credentials[:dgfip_liasse_fiscale_declaration_url]}" }
  c.filter_sensitive_data('<URL_DGFIP_LIASSE_DICO>'       ) { "#{Siade.credentials[:dgfip_liasse_fiscale_dictionnaire_url]}" }

  c.filter_sensitive_data('<URL_QUALIBAT>') { "#{Siade.credentials[:qualibat_url]}" }
end
