RSpec.describe FranceTravail::Indemnites::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params: { identifiant_pole_emploi: }, response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:identifiant_pole_emploi) { 'whatever' }
  let(:body) { read_payload_file('pole_emploi/indemnites/valid.json') }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          identifiant: identifiant_pole_emploi,
          paiements: [
            {
              date: Date.new(2023, 7, 3),
              montant: 123.4,
              allocations: 123.4,
              aides: 0.0,
              autres: 0.0
            }
          ]
        }
      )
    end
  end
end
