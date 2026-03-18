RSpec.describe SIADE::V3::Responses::Geo::Generic, type: :provider_response do
  subject { SIADE::V3::Requests::Geo::Localite.new(code).tap(&:perform).response }

  context 'when code is not found', vcr: { cassette_name: 'geo/commune/non_existent' } do
    let(:code) { GeoHelper.non_existent(:commune) }

    its(:http_code) { is_expected.to eq 404 }
  end

  GeoHelper.valid(:communes).each do |code_commune|
    context "when code #{code_commune} is found", vcr: { cassette_name: "geo/commune/#{code_commune}" } do
      let(:code) { code_commune }

      its(:http_code) { is_expected.to eq 200 }
    end
  end
end
