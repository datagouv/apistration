RSpec.describe CNAV::RevenuSolidariteActive::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) do
    read_payload_file('cnav/revenu_solidarite_active/valid_beneficiaire_non_majore.json')
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    describe 'when beneficiaire is non majore' do
      let(:body) do
        read_payload_file('cnav/revenu_solidarite_active/valid_beneficiaire_non_majore.json')
      end

      it do
        expect(subject).to eq(
          {
            status: 'beneficiaire',
            est_beneficiaire: true,
            avec_majoration: false,
            date_debut_droit: '2024-04-01',
            date_fin_droit: null
          }
        )
      end
    end

    describe 'when beneficiaire is majore' do
      let(:body) do
        read_payload_file('cnav/revenu_solidarite_active/valid_beneficiaire_majore.json')
      end

      it do
        expect(subject).to eq(
          {
            status: 'beneficiaire',
            est_beneficiaire: true,
            avec_majoration: true,
            date_debut_droit: '2024-04-01',
            date_fin_droit: null
          }
        )
      end
    end
  end
end
