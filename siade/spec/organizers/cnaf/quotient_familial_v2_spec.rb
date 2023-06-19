RSpec.describe CNAF::QuotientFamilialV2, type: :retriever_organizer do
  describe '.call' do
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
        request_id: SecureRandom.uuid,
        user_siret: valid_siret,
        annee: 2023,
        mois: 12
      }
    end

    let(:gender) { 'M' }

    describe 'happy path' do
      before do
        stub_cnaf_quotient_familial_v2_authenticate
        stub_cnaf_quotient_familial_v2_valid
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
end
