require 'rails_helper'

RSpec.describe 'API Particulier v2 CNAV: Quotient Familial with names not sent as strings', api: :particulierv2 do
  subject(:call_endpoint) do
    get '/api/v2/composition-familiale-v2',
      params: {
        recipient: valid_siret,
        nomNaissance: 'CHAMPION',
        prenoms: %w[JEAN-PASCAL],
        sexe: 'M',
        anneeDateDeNaissance: 1980,
        moisDateDeNaissance: 6,
        jourDateDeNaissance: 12,
        codePaysLieuDeNaissance: '99100',
        codeInseeLieuDeNaissance: '17300'
      }.merge(name_params),
      headers: { 'X-Api-Key' => TokenFactory.new(%i[cnaf_quotient_familial]).valid }
  end

  let!(:cnav_authentication) { stub_cnav_authenticate('quotient_familial_v2') }

  shared_examples 'a name rejected before calling the CNAV' do |reason|
    it 'responds with the name validation error without calling the CNAV' do
      call_endpoint

      expect(response).to have_http_status(:bad_request)
      expect(response_json[:reason]).to eq(reason)
      expect(cnav_authentication).not_to have_been_requested
    end
  end

  context 'when the prenoms are sent as a hash' do
    let(:name_params) { { prenoms: { '0' => 'JEAN' } } }

    it_behaves_like 'a name rejected before calling the CNAV', 'Le ou les prénoms sont manquants.'
  end

  context 'when a prenom is sent as a hash' do
    let(:name_params) { { prenoms: [{ first: 'JEAN' }] } }

    it_behaves_like 'a name rejected before calling the CNAV', 'Le ou les prénoms sont manquants.'
  end

  context 'when the nom d’usage is sent as a hash' do
    let(:name_params) { { nomUsage: { first: 'DUPONT' } } }

    it_behaves_like 'a name rejected before calling the CNAV',
      'Le nom d\'usage contient des caractères non autorisés : seuls les lettres, les espaces, les tirets et les apostrophes sont acceptés'
  end

  context 'when the nom de naissance is sent as a hash' do
    let(:name_params) { { nomNaissance: { first: 'CHAMPION' } } }

    it_behaves_like 'a name rejected before calling the CNAV', 'Le nom de naissance est manquant'
  end
end
