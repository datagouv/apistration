RSpec.describe SIADE::V2::Responses::Associations, type: :provider_response do
  subject { SIADE::V2::Requests::Associations.new('W000000000').perform.response }

  context 'when body describe a 404', vcr: { cassette_name: 'rna_association/W000000000' } do
    it '404 when 200 with body describing errors describe http code and success' do
      expect(subject.raw_response.code).to eq('200')
      expect(subject.http_code).to eq(404)
    end

    its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
  end
end
