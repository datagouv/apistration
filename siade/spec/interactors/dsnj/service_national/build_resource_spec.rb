RSpec.describe DSNJ::ServiceNational::BuildResource, type: :build_resource do
  subject(:instance) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { read_payload_file('dsnj/service_national/found.json') }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          statut_service_national: 'en_regle',
          commentaires: 'Complément'
        }
      )
    end
  end
end
