require 'rails_helper'

RSpec.describe 'Endpoint ping URLs consistency' do # rubocop:disable RSpec/DescribeClass
  let(:ping_keys) do
    YAML.safe_load_file(Rails.root.join('config/pings.yml'), aliases: true)
      .fetch('shared')
      .transform_values(&:keys)
  end

  let(:ping_url_patterns) do
    {
      'api_entreprise' => %r{\Ahttps://entreprise\.api\.gouv\.fr/ping/(?<key>.+)\z},
      'api_particulier' => %r{\Ahttps://particulier\.api\.gouv\.fr/api/(?<key>[^/]+)/ping\z}
    }
  end

  let(:endpoints_released_without_ping) do
    {
      'siaf/fondations' => 'ping added by https://github.com/datagouv/apistration/pull/737',
      'inpi/rne/attestation_immatriculation' => 'released in beta before pings were required',
      'agence_bio/certifications_bio' => 'released before pings were required',
      'cnav/foyer_rsa' => 'released in beta before pings were required'
    }
  end

  let(:endpoints) { APIEntreprise::Endpoint.all + APIParticulier::Endpoint.all + APIParticulier::EndpointV2.all }

  it 'gives a ping_url to every endpoint out of prochainement and not deprecated' do
    missing = endpoints.select { |endpoint|
      endpoint.ping_url.blank? &&
        !endpoint.incoming? &&
        !endpoint.deprecated? &&
        endpoints_released_without_ping.exclude?(endpoint.uid)
    }.map(&:uid)

    expect(missing).to be_empty,
      "Endpoints in production without ping_url (add an entry to commons/pings.yml, then the ping_url to the fiche):\n#{missing.map { |uid| "  #{uid}" }.join("\n")}"
  end

  it 'points every ping_url to a ping declared in commons/pings.yml' do
    invalid = endpoints.each_with_object([]) do |endpoint, acc|
      next if endpoint.ping_url.blank?

      match = endpoint.ping_url.match(ping_url_patterns.fetch(endpoint.api))

      if match.nil?
        acc << "#{endpoint.uid}: ping_url '#{endpoint.ping_url}' does not match #{ping_url_patterns.fetch(endpoint.api).source}"
      elsif ping_keys.fetch(endpoint.api).exclude?(match[:key])
        acc << "#{endpoint.uid}: ping '#{match[:key]}' is not declared in commons/pings.yml under shared.#{endpoint.api}"
      end
    end

    expect(invalid).to be_empty,
      "Broken ping URLs:\n#{invalid.map { |line| "  #{line}" }.join("\n")}"
  end
end
