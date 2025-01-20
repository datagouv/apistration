RSpec.describe FranceConnect::ValidateResponse do
  class FranceConnectDummyDataFetcher < described_class
    def scopes
      %w[openid identite_pivot family_name given_name gender birthdate birthplace birthcountry]
    end

    def params_to_verify # rubocop:disable Metrics/AbcSize
      {
        nom_naissance: json_body['token_introspection']['family_name'],
        prenoms: json_body['token_introspection']['given_name_array'],
        annee_date_naissance: json_body['token_introspection']['birthdate'].split('-').first,
        mois_date_naissance: json_body['token_introspection']['birthdate'].split('-').second,
        jour_date_naissance: json_body['token_introspection']['birthdate'].split('-').third
      }
    end
  end

  describe 'FranceConnect received param validation' do
    subject(:call) { FranceConnectDummyDataFetcher.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    let(:code) { 200 }

    let(:body) do
      {
        aud: 'whatever',
        iss: 'whatever',
        token_introspection: {
          active: true,
          scope: %w[openid identite_pivot family_name given_name gender birthdate birthplace birthcountry],
          given_name_array:,
          family_name:,
          birthdate:
        }
      }.to_json
    end

    let(:family_name) { 'Doe' }
    let(:given_name_array) { %w[John] }
    let(:birthdate) { '1990-01-01' }

    describe 'when all params are valid' do
      it { is_expected.to be_a_success }

      it 'does not tracks errors' do
        expect(MonitoringService.instance).not_to receive(:track)

        subject
      end
    end

    describe 'when a param is wrong' do
      let(:given_name_array) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }

      it 'tracks errors' do
        expect(MonitoringService.instance).to receive(:track)

        subject
      end
    end
  end
end
