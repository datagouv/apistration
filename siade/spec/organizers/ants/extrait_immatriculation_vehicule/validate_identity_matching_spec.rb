RSpec.describe ANTS::ExtraitImmatriculationVehicule::ValidateIdentityMatching do
  subject { described_class.call(response:, params:) }

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

  let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

  describe 'when response body matches the personne physique' do
    let(:body) { read_payload_file('ants/found_siv.xml') }

    before do
      success_context = Interactor::Context.new(matchings: { 'familyname' => true, 'givenname' => true }, matches: true)

      allow(IdentityMatcher).to receive(:call)
        .with(candidate_identity: anything, reference_identity: anything)
        .and_return(success_context)
    end

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  describe 'when response body doesnt match the personne physique' do
    let(:body) { read_payload_file('ants/found_personne_morale_siv.xml') }

    before do
      failed_context = Interactor::Context.new(matchings: {}, matches: false)
      allow(failed_context).to receive(:success?).and_return(false)

      allow(IdentityMatcher).to receive(:call)
        .with(candidate_identity: anything, reference_identity: anything)
        .and_return(failed_context)

      allow(DataEncryptor).to receive(:new).and_return(
        instance_double(DataEncryptor, encrypt: 'stubbed_encrypted_data')
      )
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
