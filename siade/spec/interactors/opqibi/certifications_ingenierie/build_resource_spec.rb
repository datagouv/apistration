RSpec.describe OPQIBI::CertificationsIngenierie::BuildResource, type: :build_resource do
  subject { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    OPQIBI::CertificationsIngenierie::MakeRequest.call(params:).response.body
  end

  let(:params) do
    {
      siren:
    }
  end

  let(:siren) { valid_siren(:opqibi_with_probatoire) }

  let(:valid_payload) do
    {
      numero_certificat: '12 34 5678',
      url: 'https://www.opqibi.com/fiche/9876',
      date_delivrance_certificat: '2021-06-15',
      duree_validite_certificat: 'valable un an',
      assurances: 'ANONYME',
      qualifications: [
        {
          nom: 'Étude en ingénierie thermique',
          code_qualification: '2001',
          definition: 'Optimisation énergétique des bâtiments',
          rge: false
        },
        {
          nom: 'Ingénierie en efficacité énergétique',
          code_qualification: '2002',
          definition: 'Amélioration de la performance',
          rge: false
        }
      ],
      date_validite_qualifications: '2024-06-15',
      qualifications_probatoires: [
        {
          code_qualification: '2003',
          nom: 'Ingénierie en énergies renouvelables',
          definition: 'Développement durable et écologie',
          rge: false
        }
      ],
      date_validite_qualifications_probatoires: '2022-06-15'
    }
  end

  describe '.call', vcr: { cassette_name: 'opqibi/certifications_ingenierie/valid_siren' } do
    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_a(Resource)
      expect(resource.to_h).to eq(valid_payload)
    end
  end

  describe 'non-regression test: when qualifications_probatoires is empty, date_de_validite_qualifications_probatoires is missing',
    vcr: { cassette_name: 'opqibi/certifications_ingenierie/valid_siren' } do
    let(:body) do
      body = OPQIBI::CertificationsIngenierie::MakeRequest.call(params:).response.body
      JSON.parse(body).except('date_de_validite_des_qualifications_probatoires').to_json
    end

    it { is_expected.to be_a_success }
  end
end
