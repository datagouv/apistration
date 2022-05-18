RSpec.describe SIADE::V2::Drivers::CertificatsAgenceBIO, type: :provider_driver do
  context 'when there is no active certifications for the given siret', vcr: { cassette_name: 'agence_bio/with_not_found_siret' } do
    subject { described_class.new(siret: siret).perform_request }

    let(:siret) { not_found_siret(:agence_bio) }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'when Agence Bio returns more than one result for a given siret', vcr: { cassette_name: 'agence_bio/with_duplicate_siret' } do
    subject { described_class.new(siret: siret).perform_request }

    let(:siret) { agence_bio_duplicated_siret }

    its(:http_code) { is_expected.to eq(200) }

    its(:errors) { is_expected.to be_empty }

    its(:filtered_certifications_data) do
      is_expected.to all(include(
        :siret,
        :numero_bio,
        :date_derniere_mise_a_jour,
        :reseau,
        :categories,
        :activites,
        :productions,
        :adresses_operateurs,
        :certificats
      ))
    end
  end

  context 'when there are active certifications for the given siret', vcr: { cassette_name: 'agence_bio/with_valid_siret' } do
    subject do
      driver = described_class.new(siret: siret).perform_request
      driver.filtered_certifications_data
    end

    let(:siret) { valid_siret(:agence_bio) }

    it 'contains organic operator data' do
      expect(subject).to contain_exactly(a_hash_including({
        siret: '88375327900016',
        numero_bio: 15_727,
        date_derniere_mise_a_jour: '2022-04-27',
        reseau: ''
      }))
    end

    it 'contains categories data' do
      expect(subject).to contain_exactly(a_hash_including({
        categories: a_collection_including('Grossistes')
      }))
    end

    it 'contains activities data' do
      expect(subject).to contain_exactly(a_hash_including({
        activites: a_collection_containing_exactly(
          'Préparation',
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
        nom: String,
        code: String
      ))
    end

    it 'contains the certificats data' do
      expect(subject).to contain_exactly(
        a_hash_including(
          certificats: a_hash_including(
            organisme: 'Ecocert France',
            date_engagement: '2020-08-10',
            url: 'http://certificat.ecocert.com/index.php?ln=fr&source=agencebio&id=230419',
            etat_certification: 'ENGAGEE',
            date_arret: nil,
            date_suspension: nil
          )
        )
      )
    end
  end
end
