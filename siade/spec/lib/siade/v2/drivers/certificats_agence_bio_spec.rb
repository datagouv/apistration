RSpec.describe SIADE::V2::Drivers::CertificatsAgenceBIO, type: :provider_driver do
  context 'when there is no active certifications for the given siret', vcr: { cassette_name: 'agence_bio/with_not_found_siret' } do
    let(:siret) { not_found_siret(:agence_bio) }

    subject { described_class.new(siret: siret).perform_request }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when Agence Bio returns more than one result for a given siret', vcr: { cassette_name: 'agence_bio/with_duplicate_siret' } do
    let(:siret) { agence_bio_duplicated_siret }

    subject { described_class.new(siret: siret).perform_request }

    its(:http_code) { is_expected.to eq(200) }

    its(:errors) { is_expected.to be_empty }

    its(:filtered_certifications_data) do
      is_expected.to all(include(
        :raison_sociale,
        :denomination_courante,
        :siret,
        :numero_bio,
        :date_derniere_mise_a_jour,
        :numero_pacage,
        :reseau,
        :categories,
        :activites,
        :productions,
        :adresses_operateurs,
        :certificats,
      ))
    end
  end

  context 'when there are active certifications for the given siret', vcr: { cassette_name: 'agence_bio/with_valid_siret' } do
    let(:siret) { valid_siret(:agence_bio) }

    subject do
      driver = described_class.new(siret: siret).perform_request
      driver.filtered_certifications_data
    end

    it 'contains organic operator data' do
      is_expected.to contain_exactly(a_hash_including({
        raison_sociale:            'La bio pep\'s',
        denomination_courante:     'Donnée indisponible',
        siret:                     '48311105000025',
        numero_bio:                18344,
        date_derniere_mise_a_jour: '2020-10-27',
        numero_pacage:             nil,
        reseau:                    '',
      }))
    end

    it 'contains categories data' do
      is_expected.to contain_exactly(a_hash_including({
        categories: a_collection_including('Vente aux consommateurs')
      }))
    end

    it 'contains activities data' do
      is_expected.to contain_exactly(a_hash_including({
        activites: a_collection_containing_exactly(
          'Production',
          'Distribution',
          'Stockage',
        )
      }))
    end

    it 'contains operator\'s addresses' do
      adresses = subject.first[:adresses_operateurs]

      expect(adresses).to all(include(
        :lieu,
        :code_postal,
        :ville,
        :lat,
        :long,
        type: a_collection_including(String)
      ))
    end

    it 'contains the production details' do
      prods = subject.first[:productions]

      expect(prods).to all(include(
        nom:  String,
        code: String,
      ))
    end

    it 'contains the certificats data' do
      is_expected.to contain_exactly(
        a_hash_including(
          certificats: a_hash_including(
            organisme:          'Certipaq',
            date_engagement:    '2020-09-29',
            url:                'https://www.certipaq.solutions/bio/certificats/fiche/56530/barbot-fabrice/',
            etat_certification: 'ENGAGEE',
            date_arret:         nil,
            date_suspension:    nil,
          ),
        )
      )
    end
  end
end
