RSpec.describe APIParticulier::V2::CNAF::QuotientFamilialController do
  subject { get :show, params: { numeroAllocataire: beneficiary_number, codePostal: postal_code, token: } }

  let(:all_scopes) { %i[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse] }

  describe 'with valid params' do
    let(:token) { TokenFactory.new(scopes).valid }

    let(:postal_code) { '75001' }
    let(:beneficiary_number) { '1234567' }

    before do
      mock_valid_cnaf_quotient_familial
    end

    context 'when token has full access' do
      let(:scopes) { all_scopes }

      its(:status) { is_expected.to eq(200) }

      it 'returns all fields' do
        json = JSON.parse(subject.body)

        %w[allocataires enfants adresse quotientFamilial mois annee].each do |key|
          expect(json).to have_key(key), "#{key} is missing"
        end
      end
    end

    context 'when cnaf_allocataires is missing' do
      let(:scopes) { all_scopes - %i[cnaf_allocataires] }

      it 'does not return this field' do
        json = JSON.parse(subject.body)

        %w[enfants adresse quotientFamilial mois annee].each do |key|
          expect(json).to have_key(key), "#{key} is missing"
        end

        expect(json).not_to have_key('allocataires')
      end
    end
  end
end
