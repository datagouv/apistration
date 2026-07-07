RSpec.describe CNAV::AllocationRentreeScolaire::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) do
    read_payload_file('cnav/allocation_rentree_scolaire/valid_beneficiaire.json')
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    context 'when the status is allocataire' do
      it do
        expect(subject).to eq(
          {
            status: 'allocataire',
            date_debut_droit: '2024-08-09'
          }
        )
      end
    end

    context 'when the status is ouvrant_droit' do
      let(:body) do
        read_payload_file('cnav/allocation_rentree_scolaire/valid_beneficiaire_ouvrant_droit.json')
      end

      it do
        expect(subject).to eq(
          {
            status: 'ouvrant_droit',
            date_debut_droit: '2024-08-09'
          }
        )
      end
    end

    context 'when the status is non_beneficiaire' do
      let(:body) do
        read_payload_file('cnav/allocation_rentree_scolaire/non_beneficiaire.json')
      end

      it do
        expect(subject).to eq(
          {
            status: 'non_beneficiaire',
            date_debut_droit: nil
          }
        )
      end
    end
  end
end
