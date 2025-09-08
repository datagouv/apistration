RSpec.describe ANTS::ExtraitImmatriculationVehicule::ValidateOneIdentityIsMatching, type: :validate_response do
  subject { described_class.call(extracted_identities:, params:) }

  let(:params) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      sexe_etat_civil: 'M',
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8,
      code_cog_insee_commune_naissance: '59001'
    }
  end

  let(:match_identity_result) { instance_double(Interactor::Context, success?: match_result) }

  before do
    allow(IdentityMatcher).to receive(:call)
      .with(candidate_identity: anything, reference_identity: anything)
      .and_return(match_identity_result)
  end

  describe 'when identity matches' do
    let(:match_result) { true }
    let(:extracted_identities) do
      [{
        libelle_type_personne: 'Proprietaire',
        identite_from_ants: {
          nom_naissance: 'DUPONT',
          prenoms: ['JEAN'],
          sexe_etat_civil: 'M',
          annee_date_naissance: 1955,
          mois_date_naissance: 12,
          jour_date_naissance: 8
        },
        address_from_ants: {}
      }]
    end

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }

    it 'stores the matched identity in the context' do
      expect(subject.matched_identity).to eq(extracted_identities.first)
    end
  end

  describe 'when no identity matches' do
    let(:match_result) { false }
    let(:extracted_identities) do
      [{
        libelle_type_personne: 'Proprietaire',
        identite_from_ants: {
          nom_naissance: 'MARTIN',
          prenoms: ['PAUL'],
          sexe_etat_civil: 'M',
          annee_date_naissance: 1960,
          mois_date_naissance: 5,
          jour_date_naissance: 15
        },
        address_from_ants: {}
      }]
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

    it 'returns the specific error message for no matching identity' do
      expect(subject.errors.first.detail).to eq('Immatriculation trouvée mais aucune identité ne correspond')
    end

    it 'returns the specific subcode for no matching identity' do
      expect(subject.errors.first.subcode).to eq('005')
    end
  end

  describe 'when extracted identities is empty' do
    let(:extracted_identities) { [] }
    let(:match_result) { false }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
