RSpec.describe INPI::RNE::ActesBilans, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:,
      token_id:
    }
  end
  let(:token_id) { 'c1a72399-2fdd-427e-a9f7-dc480f158603' }
  let(:siren) { valid_siren(:inpi) }

  before(:all) do
    Timecop.freeze
  end

  after(:all) do
    Timecop.return
  end

  describe 'resource', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    subject { described_class.call(params:).bundled_data.data }

    before { stub_inpi_rne_actes_bilans_valid(siren:) }

    it { is_expected.to be_present }

    it { is_expected.to be_a(Resource) }

    describe 'url in resources' do
      subject(:url) { described_class.call(params:).bundled_data.data.actes.first[:url] }

      it { is_expected.to be_present }

      describe 'following url', type: :request, vcr: { cassette_name: 'inpi/rne/actes_download/valid' } do
        let(:document_url_regexp) { %r{http://test\.entreprise\.api\.gouv\.fr/proxy/files/[a-f0-9-]{36}} }

        context 'with token not in database' do
          before { Token.destroy_by(id: token_id) }

          it 'fails' do
            get url

            expect(response).to have_http_status(:unauthorized)
            expect(response_json).to have_json_error(
              detail: "Votre jeton n'a pas été trouvé dans la base de données. " \
                      "Il s'agit probablement d'un jeton sans habilitation. " \
                      'Vous devez effectuer une demande à API Entreprise, un guide est ' \
                      'disponible sur https://entreprise.api.gouv.fr/demander_un_acces/'
            )
            expect(response_json).to have_json_api_format_errors
          end
        end

        context 'with valid token' do
          before(:all) do
            Token.create!(
              id: 'c1a72399-2fdd-427e-a9f7-dc480f158603',
              iat: 2.hours.ago.to_i,
              exp: 3.hours.from_now.to_i,
              authorization_request_model_id: AuthorizationRequest.create.id,
              scopes: %w[open_data]
            )
          end

          it 'returns a proxy url to download the document' do
            get url

            expect(response.parsed_body[:data][:document_url]).to match(document_url_regexp)
          end

          describe 'tracking url' do
            let(:dummy_user_context) do
              {
                blacklisted: false,
                exp: 3.hours.from_now.to_i,
                iat: Time.zone.at(2.hours.ago.to_i),
                id: token_id,
                jti: token_id,
                scopes: ['open_data'],
                siret: nil
              }
            end

            let(:tracked_params) do
              {
                action: 'show',
                controller: 'api_entreprise/inpi_proxy',
                uuid: an_instance_of(String)
              }
            end

            it 'tracks dummy user context and params in logstash' do
              expect(MonitoringService.instance).to receive(:set_user_context).with(hash_including(dummy_user_context))
              expect(MonitoringService.instance).to receive(:set_controller_params).with(tracked_params)

              get url
            end
          end
        end
      end
    end
  end
end
