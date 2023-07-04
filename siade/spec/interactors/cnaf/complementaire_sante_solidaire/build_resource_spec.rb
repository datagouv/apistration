RSpec.describe CNAF::ComplementaireSanteSolidaire::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params:, response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:params) do
    {
      annee: 2023,
      mois: 6
    }
  end

  let(:body) do
    read_payload_file('cnaf/complementaire_sante_solidaire/make_request_valid.json')
  end

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          status: 'beneficiaire_avec_participation_financiere',
          dateDebut: '2021-01-01',
          dateFin: '2022-01-01'
        }
      )
    end
  end
end
