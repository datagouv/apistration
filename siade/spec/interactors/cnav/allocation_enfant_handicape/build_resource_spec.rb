RSpec.describe CNAV::AllocationEnfantHandicape::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) do
    read_payload_file('cnav/allocation_enfant_handicape/valid_beneficiaire.json')
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    context 'when the status is allocataire' do
      it do
        expect(subject).to eq(
          {
            status: 'allocataire',
            date_debut_droit: '2021-01-01'
          }
        )
      end
    end

    context 'when the status is ouvrant_droit' do
      let(:body) do
        read_payload_file('cnav/allocation_enfant_handicape/valid_beneficiaire_ouvrant_droit.json')
      end

      it do
        expect(subject).to eq(
          {
            status: 'ouvrant_droit',
            date_debut_droit: '2021-01-01'
          }
        )
      end
    end
  end
end
