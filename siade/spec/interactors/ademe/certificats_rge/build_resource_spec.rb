RSpec.describe ADEME::CertificatsRGE::BuildResource, type: :build_resource do
  subject { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    ADEME::CertificatsRGE::MakeRequest.call(params:).response.body
  end

  let(:params) do
    {
      siret:,
      size: 10_000
    }
  end

  let(:siret) { valid_siret(:rge_ademe) }

  let(:valid_payload_entreprise) do
    {
      nom: 'MIXENERGIE',
      adresse: '25 ROUTE DE LOUHANS',
      code_postal: '71440',
      commune: 'MONTRET',
      latitude: 46.717769,
      longitude: 5.18096,
      telephone: '03 85 43 50 00',
      site_internet: 'http://www.mixenergie.fr',
      email: 'malo@mixenergie.fr',
      particuliers: true
    }
  end

  let(:valid_payload_certificat_1) do
    {
      id: 'Q112379-8611M12D108-2022-03-30',
      url: 'https://www.qualibat.com/Views/GetFichier.aspx?fn=2022\\D71-Certificat-112379-MIXENERGIE-E112379-2-20220214-RGEAnnexe.pdf',
      nom_certificat: 'QUALIBAT-RGE',
      domaine: 'Ventilation mécanique',
      meta_domaine: "Travaux d'efficacité énergétique",
      code_qualification: '8611M12D108',
      nom_qualification: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste (8611M12D108)',
      organisme: 'qualibat',
      date_attribution: '2019-01-24',
      date_expiration: '2023-02-04',
      updated_at: '2022-03-30'
    }
  end

  let(:valid_payload_certificat_2) do
    {
      id: 'Q112379-8611M12D108-2022-02-15',
      url: 'http://www.qualibat.com/Views/GetFichier.aspx?fn=2022\\D71-Certificat-112379-MIXENERGIE-E112379-2-20220214-RGEAnnexe.pdf',
      nom_certificat: 'QUALIBAT-RGE',
      domaine: 'Ventilation mécanique',
      meta_domaine: "Travaux d'efficacité énergétique",
      code_qualification: '8611M12D108',
      nom_qualification: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste (8611M12D108)',
      organisme: 'qualibat',
      date_attribution: '2019-01-24',
      date_expiration: '2023-02-04',
      updated_at: '2022-03-30'
    }
  end

  describe '.call', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
    subject { described_class.call(response:, params:) }

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(subject.resource).to be_a(Resource)

      expect(subject.resource.to_h[:entreprise]).to eq(valid_payload_entreprise)
      expect(subject.resource.to_h[:certificats][0]).to eq(valid_payload_certificat_1)
      expect(subject.resource.to_h[:certificats][1]).to eq(valid_payload_certificat_2)
    end
  end
end
