RSpec.describe ADEME::CertificatsRGE::BuildResourceCollection, type: :build_resource do
  subject { described_class.call(response:, params:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    ADEME::CertificatsRGE::MakeRequest.call(params:).response.body
  end

  let(:params) do
    {
      siret:,
      limit:
    }
  end

  let(:siret) { valid_siret(:rge_ademe) }
  let(:limit) { 2 }

  let(:valid_meta) do
    {
      total: 9
    }
  end

  let(:valid_collection) do
    [
      {
        url: 'https://www.qualibat.com/Views/GetFichier.aspx?fn=2022\\D75-Certificat-112379-EXEMPLE-ENERGIE-E112379-2-20220214-RGEAnnexe.pdf',
        nom_certificat: 'QUALIBAT-RGE',
        domaine: 'Ventilation mécanique',
        meta_domaine: "Travaux d'efficacité énergétique",
        qualification: {
          code: '8611M12D108',
          nom: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste (8611M12D108)'
        },
        organisme: 'qualibat',
        date_attribution: '2019-01-24',
        date_expiration: '2023-02-04',
        meta: {
          internal_id: 'Q112379-8611M12D108-2022-03-30',
          archived: false,
          updated_at: '2022-03-30'
        }
      },
      {
        url: 'https://www.qualibat.com/Views/GetFichier.aspx?fn=2022\\D75-Certificat-112379-EXEMPLE-ENERGIE-E112379-2-20220214-RGEAnnexe.pdf',
        nom_certificat: 'QUALIBAT-RGE',
        domaine: 'Radiateurs électriques, dont régulation.',
        meta_domaine: "Travaux d'efficacité énergétique",
        qualification: {
          code: '8611M12D107',
          nom: 'Efficacité énergétique - "ECO Artisan®" - Chauffagiste (8611M12D107)'
        },
        organisme: 'qualibat',
        date_attribution: '2019-01-24',
        date_expiration: '2023-02-04',
        meta: {
          internal_id: 'Q112379-8611M12D107-2022-03-30',
          archived: false,
          updated_at: '2022-03-30'
        }
      }
    ]
  end

  describe '.call', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret_with_limit' } do
    let(:resource_collection) { subject.bundled_data.data }
    let(:meta) { subject.bundled_data.context }

    it { is_expected.to be_a_success }

    it 'retrieves the resource collection' do
      expect(resource_collection).to all(be_a(Resource))
    end

    it 'retrieves the meta' do
      expect(meta).to eq(valid_meta)
    end

    it 'builds valid resource collection' do
      expect(resource_collection.map(&:to_h)).to eq(valid_collection)
    end
  end
end
