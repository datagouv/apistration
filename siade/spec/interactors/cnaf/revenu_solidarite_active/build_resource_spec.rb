RSpec.describe CNAF::RevenuSolidariteActive::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) do
    read_payload_file('cnaf/revenu_solidarite_active/valid_beneficiaire_non_majore.json')
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    describe 'when beneficiaire is non majore' do
      let(:body) do
        read_payload_file('cnaf/revenu_solidarite_active/valid_beneficiaire_non_majore.json')
      end

      it do
        expect(subject).to eq(
          {
            status: 'beneficiaire',
            majoration: false,
            dateDebut: '2024-04-01',
            dateFin: '2024-07-01'
          }
        )
      end
    end

    describe 'when beneficiaire is majore' do
      let(:body) do
        read_payload_file('cnaf/revenu_solidarite_active/valid_beneficiaire_majore.json')
      end

      it do
        expect(subject).to eq(
          {
            status: 'beneficiaire',
            majoration: true,
            dateDebut: '2024-04-01',
            dateFin: '2024-07-01'
          }
        )
      end
    end
  end
end
