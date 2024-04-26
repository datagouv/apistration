RSpec.describe INSEE::Successions::BuildResource, type: :build_resource do
  subject(:organizer) { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) { INSEE::Successions::MakeRequest.call(params:).response.body }

  let(:params) { { siret: } }

  describe 'with a response containing only one succession' do
    let(:body) { read_payload_file('insee/succession_valid.json') }

    context 'when the requested SIRET is predecesseur' do
      let(:siret) { '12345678900015' }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:predecesseurs) { is_expected.to be_empty }

        its(:successeurs) do
          is_expected.to eq([
            {
              siret: '12345678900031',
              date_succession: '2015-01-09',
              transfert_siege: true,
              continuite_economique: true
            }
          ])
        end
      end
    end

    context 'when the requested SIRET is successeur' do
      let(:siret) { '12345678900031' }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:successeurs) { is_expected.to be_empty }

        its(:predecesseurs) do
          is_expected.to eq([
            {
              siret: '12345678900015',
              date_succession: '2015-01-09',
              transfert_siege: true,
              continuite_economique: true
            }
          ])
        end
      end
    end
  end

  describe 'with a response containing multiple successions' do
    let(:body) { read_payload_file('insee/succession_valid_multiple.json') }
    let(:siret) { sirets_insee_v3[:successions] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:predecesseurs) do
        is_expected.to eq([
          {
            siret: '30006240940008',
            date_succession: '2011-04-01',
            transfert_siege: false,
            continuite_economique: false
          },
          {
            siret: '30006240940024',
            date_succession: '2011-04-01',
            transfert_siege: false,
            continuite_economique: true
          }
        ])
      end

      its(:successeurs) do
        is_expected.to eq([
          {
            siret: '30006240940057',
            date_succession: '2012-10-31',
            transfert_siege: false,
            continuite_economique: true
          }
        ])
      end
    end
  end
end
