RSpec.describe BanqueDeFrance::BilansEntreprise::BuildResourceCollection, type: :build_resource do
  subject { organizer }

  let(:organizer) { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
  let(:body) { build_banque_de_france_response(json_body) }
  let(:params) do
    {
      user_id:,
      request_id:
    }
  end

  let(:user_id) { SecureRandom.uuid }
  let(:request_id) { SecureRandom.uuid }

  let(:json_body) { open_payload_file('banque_de_france/bilans_entreprise_valid_data.json').read }

  before do
    mock_valid_dgfip_dictionnaire(2022)
    mock_valid_dgfip_dictionnaire(2021)
  end

  it { is_expected.to be_a_success }

  it 'builds valid resources' do
    expect(organizer.bundled_data.data).to all be_a(Resource)
  end

  describe 'declarations item' do
    subject { organizer.bundled_data.data.first.declarations }

    it 'has augmented information from the remote dictionary first, then from the local one' do
      imprime_2051 = subject.find { |declaration| declaration[:numero_imprime] == '2051' }
      intitules_by_code_nref = imprime_2051[:donnees].to_h { |datum| [datum[:code_nref], datum[:intitule]] }

      expect(intitules_by_code_nref).to include(
        '300438' => 'Déposé géant',
        '300476' => 'Réposé géant',
        '300414' => 'Capital social ou individuel n'
      )
    end
  end
end
