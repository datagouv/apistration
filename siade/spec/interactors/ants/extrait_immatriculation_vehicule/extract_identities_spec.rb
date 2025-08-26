RSpec.describe ANTS::ExtraitImmatriculationVehicule::ExtractIdentities do
  subject { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

  describe 'when response body contains identities' do
    let(:body) { read_payload_file('ants/found_siv.xml') }

    it { is_expected.to be_a_success }

    it 'extracts identities from response' do
      expect(subject.extracted_identities).to be_an(Array)
      expect(subject.extracted_identities).not_to be_empty
    end

    it 'extracts identity data correctly' do
      identity = subject.extracted_identities.first

      expect(identity).to have_key(:libelle_type_personne)
      expect(identity).to have_key(:identite_from_ants)
      expect(identity).to have_key(:address_from_ants)

      expect(identity[:libelle_type_personne]).to eq('titulaire')

      expect(identity[:identite_from_ants]).to have_key(:nom_naissance)
      expect(identity[:identite_from_ants]).to have_key(:prenoms)
      expect(identity[:identite_from_ants]).to have_key(:sexe_etat_civil)
      expect(identity[:identite_from_ants]).to have_key(:annee_date_naissance)
      expect(identity[:identite_from_ants]).to have_key(:mois_date_naissance)
      expect(identity[:identite_from_ants]).to have_key(:jour_date_naissance)
      expect(identity[:identite_from_ants]).to have_key(:code_departement_naissance)

      expect(identity[:identite_from_ants][:nom_naissance]).to eq('DUPONT')
      expect(identity[:identite_from_ants][:prenoms]).to eq(['JEAN'])
      expect(identity[:identite_from_ants][:sexe_etat_civil]).to eq('M')
      expect(identity[:identite_from_ants][:annee_date_naissance]).to eq(2000)
      expect(identity[:identite_from_ants][:mois_date_naissance]).to eq(1)
      expect(identity[:identite_from_ants][:jour_date_naissance]).to eq(1)
      expect(identity[:identite_from_ants][:code_departement_naissance]).to eq('75')

      expect(identity[:address_from_ants]).to have_key(:num_voie)
      expect(identity[:address_from_ants]).to have_key(:type_voie)
      expect(identity[:address_from_ants]).to have_key(:libelle_voie)
      expect(identity[:address_from_ants]).to have_key(:code_postal_ville)
      expect(identity[:address_from_ants]).to have_key(:libelle_commune)
      expect(identity[:address_from_ants]).to have_key(:pays)
    end
  end

  describe 'when response body has no identities' do
    let(:body) { read_payload_file('ants/not_found.xml') }

    it { is_expected.to be_a_success }

    it 'returns empty array' do
      expect(subject.extracted_identities).to eq([])
    end
  end
end
