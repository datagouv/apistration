RSpec.describe DGFIP::Dictionaries::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }
  let(:body) { open_payload_file('dgfip/dictionary.json').read }
  let(:dictionnaire) { JSON.parse(body)['dictionnaire'] }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq({
        dictionnaire:
      })
    end
  end
end
