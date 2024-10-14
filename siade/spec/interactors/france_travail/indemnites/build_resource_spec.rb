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
              date_versement: Date.new(2023, 7, 3),
              montant_total: 123.4,
              montant_allocations: 123.4,
              montant_aides: 0.0,
              montant_autres: 0.0
            }
          ]
        }
      )
    end
  end
end
