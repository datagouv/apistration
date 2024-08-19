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

    Token.create!(
      id: 'c1a72399-2fdd-427e-a9f7-dc480f158603',
      iat: 2.hours.ago.to_i,
      exp: 3.hours.from_now.to_i,
      authorization_request_model_id: AuthorizationRequest.create.id,
      scopes: %w[open_data]
    )
  end

  after(:all) do
    Timecop.return
  end

  context 'with valid siren', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    before { stub_inpi_rne_actes_bilans_valid(siren:) }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { described_class.call(params:).bundled_data.data }

      it { is_expected.to be_present }

      it { is_expected.to be_a(Resource) }

      describe 'links in resources' do
        subject(:link) { described_class.call(params:).bundled_data.data.actes.first[:link] }

        it { is_expected.to be_present }

        describe 'following link', type: :request, vcr: { cassette_name: 'inpi/rne/actes_download/valid' } do
          subject { response }

          let(:document_url_regexp) { %r{http://test\.entreprise\.api\.gouv\.fr/proxy/files/[a-f0-9\-]{36}} }

          it 'returns a proxy link to download the document' do
            get link

            expect(response.parsed_body[:data][:document_url]).to match(document_url_regexp)
          end

          describe 'tracking link' do
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
              expect(MonitoringService.instance).to receive(:set_user_context).with(dummy_user_context)
              expect(MonitoringService.instance).to receive(:set_controller_params).with(tracked_params)

              get link
            end
          end
        end
      end
    end
  end
end
