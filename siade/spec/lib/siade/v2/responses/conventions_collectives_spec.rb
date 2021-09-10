RSpec.describe SIADE::V2::Responses::ConventionsCollectives, type: :provider_response do
  context 'when no are conventions collectives are found' do
    subject { SIADE::V2::Requests::ConventionsCollectives.new(siret).perform.response }

    let(:siret) { not_found_siret(:conventions_collectives) }

    it 'returns 404', vcr: { cassette_name: 'conventions_collectives_with_not_found_siret' } do
      # The data provider respond with an HTTP code 200 and an empty body
      expect(subject.raw_response.code).to eq('200')
      expect(subject.http_code).to eq(404)
    end
  end
end
