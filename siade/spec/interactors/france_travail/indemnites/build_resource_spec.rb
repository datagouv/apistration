RSpec.describe FranceTravail::Indemnites::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params: { identifiant: }, response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:identifiant) { 'whatever' }
  let(:body) { read_payload_file('france_travail/indemnites/valid.json') }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          identifiant:,
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
