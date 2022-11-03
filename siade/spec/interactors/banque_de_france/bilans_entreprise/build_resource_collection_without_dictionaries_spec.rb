RSpec.describe BanqueDeFrance::BilansEntreprise::BuildResourceCollectionWithoutDictionaries, type: :build_resource do
  subject(:call) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) { build_banque_de_france_response(json_body) }
  let(:json_body) do
    open_payload_file('banque_de_france/bilans_entreprise_valid_data.json').read
  end

  it { is_expected.to be_a_success }

  it 'builds valid resources' do
    expect(call.bundled_data.data).to all be_a(Resource)
  end
end
