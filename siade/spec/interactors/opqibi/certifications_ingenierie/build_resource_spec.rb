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
      numero_certificat: '05 02 1690',
      url: 'https://www.opqibi.com/fiche/1777',
      date_delivrance_certificat: '2022-02-01',
      duree_validite_certificat: 'valable un an',
      assurances: 'MAF',
      qualifications: [
        {
          nom: 'Étude en acoustique',
          code_qualification: '1601',
          definition: 'Correction acoustique des salles',
          rge: false
        },
        {
          nom: 'Ingénierie en acoustique des infrastructures de transport',
          code_qualification: '1602',
          definition: 'Maîtrise des bruits',
          rge: false
        }
      ],
      date_validite_qualifications: '2025-02-01',
      qualifications_probatoires: [
        {
          code_qualification: '1603',
          nom: 'Ingénierie en acoustique industrielle',
          definition: 'Maîtrise des bruits industriels',
          rge: false
        }
      ],
      date_validite_qualifications_probatoires: '2023-02-01'
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
