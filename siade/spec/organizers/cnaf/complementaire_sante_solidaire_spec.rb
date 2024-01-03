RSpec.describe CNAF::ComplementaireSanteSolidaire, type: :retriever_organizer do
  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

  describe '.call with civility params' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: ['JEAN-PASCAL'],
        annee_date_de_naissance: 1980,
        mois_date_de_naissance: 6,
        jour_date_de_naissance: 12,
        gender:,
        code_pays_lieu_de_naissance: '99100',
        code_insee_lieu_de_naissance: '17300',
        request_id:,
        user_id: valid_siret,
        recipient:
      }
    end

    let(:gender) { 'M' }

    describe 'happy path' do
      before do
        stub_cnaf_authenticate('complementaire_sante_solidaire')
        stub_cnaf_valid('complementaire_sante_solidaire')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end

    describe 'with an invalid params' do
      let(:gender) { 'nope' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  describe '.call with FranceConnect params' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_usage: 'MARTIN',
        nom_naissance: 'DUPONT',
        prenoms: ['Jean Martin'],
        date_naissance: '2000-01-01',
        code_insee_lieu_de_naissance: '75101',
        code_pays_lieu_de_naissance: '99100',
        gender: 'M',
        user_id: 'france_connect_client_name',
        request_id:,
        recipient:
      }
    end

    describe 'happy path' do
      before do
        stub_cnaf_authenticate('complementaire_sante_solidaire')
        stub_cnaf_valid_with_franceconnect_data('complementaire_sante_solidaire')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
