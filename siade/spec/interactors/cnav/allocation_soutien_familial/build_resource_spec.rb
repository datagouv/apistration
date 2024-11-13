RSpec.describe CNAV::AllocationSoutienFamilial::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) do
    read_payload_file('cnav/allocation_soutien_familial/valid_beneficiaire.json')
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          status: 'beneficiaire',
          est_beneficiaire: true,
          date_debut_droit: '2024-04-01',
          date_fin_droit: nil
        }
      )
    end
  end
end
