RSpec.describe ANTS::ExtraitImmatriculationVehicule::ValidateOneIdentityIsMatching, type: :validate_response do
  subject { described_class.call(extracted_identities:, params:, provider_name:) }

  let(:provider_name) { 'ANTS' }

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

  describe 'when identity matches' do
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

    before do
      allow(IdentityMatcher).to receive(:call)
        .with(candidate_identity: anything, reference_identity: anything)
        .and_return(Interactor::Context.new(matchings: { 'familyname' => true, 'givenname' => true }, matches: true))
    end

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }

    it 'stores the matched identity in the context' do
      expect(subject.matched_identity).to eq(extracted_identities.first)
    end
  end

  describe 'when no identity matches' do
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

    let(:encrypted_data) { 'encrypted_params_data' }
    let(:data_encryptor) { instance_double(DataEncryptor, encrypt: encrypted_data) }

    before do
      failed_context = Interactor::Context.new(matchings: {}, matches: false)
      allow(failed_context).to receive(:success?).and_return(false)

      allow(IdentityMatcher).to receive(:call)
        .with(candidate_identity: anything, reference_identity: anything)
        .and_return(failed_context)

      allow(DataEncryptor).to receive(:new).and_return(data_encryptor)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

    it 'returns the specific error message for no matching identity' do
      expect(subject.errors.first.detail).to eq('Immatriculation trouvée mais aucune identité ne correspond')
    end

    it 'returns the specific subcode for no matching identity' do
      expect(subject.errors.first.subcode).to eq('005')
    end

    it 'tracks monitoring with encrypted params' do
      expect(MonitoringService.instance).to receive(:track_with_added_context).with(
        'info',
        '[ANTS] No matching identity found',
        { encrypted_params: encrypted_data }
      )

      subject
    end

    it 'calls DataEncryptor with params as json' do
      expect(DataEncryptor).to receive(:new).with(params.to_json)

      subject
    end
  end

  describe 'when extracted identities is empty' do
    let(:extracted_identities) { [] }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
