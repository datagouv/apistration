require 'rails_helper'

RSpec.describe 'API Particulier endpoint ping URLs consistency' do # rubocop:disable RSpec/DescribeClass
  it 'every ping_url points to a provider declared in siade/config/pings.yml' do
    pings_path = Rails.root.join('../siade/config/pings.yml')
    valid_provider_keys = YAML.safe_load_file(pings_path, aliases: true)
      .fetch('shared')
      .fetch('api_particulier')
      .keys

    invalid = APIParticulier::Endpoint.all.each_with_object([]) do |endpoint, acc|
      next if endpoint.ping_url.blank?

      match = endpoint.ping_url.match(%r{\Ahttps://particulier\.api\.gouv\.fr/api/(?<provider>[^/]+)/ping\z})

      unless match
        acc << "#{endpoint.uid}: ping_url '#{endpoint.ping_url}' does not match /api/<provider>/ping pattern"
        next
      end

      provider_key = match[:provider]

      acc << "#{endpoint.uid}: ping provider '#{provider_key}' is not declared in siade/config/pings.yml under shared.api_particulier" unless valid_provider_keys.include?(provider_key)
    end

    expect(invalid).to be_empty,
      "Broken ping URLs:\n#{invalid.map { |line| "  #{line}" }.join("\n")}"
  end
end
