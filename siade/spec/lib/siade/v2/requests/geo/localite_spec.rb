RSpec.describe SIADE::V2::Requests::Geo::Localite, type: :provider_request do
  subject { described_class.new(code).tap(&:perform) }

  shared_examples 'bad formatted code commune' do |code|
    subject { described_class.new(code).tap(&:perform) }

    its(:valid?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { is_expected.to have_error('Le code INSEE commune n\'est pas correctement formaté') }
  end

  # only check size == 5 (reminder Ajaccio: 2A004)
  it_behaves_like 'bad formatted code commune', 'nope'
  it_behaves_like 'bad formatted code commune', '123'
  it_behaves_like 'bad formatted code commune', 75_056
  it_behaves_like 'bad formatted code commune', '123456'

  context 'non existent code commune', vcr: { cassette_name: 'geo/commune/non_existent' } do
    let(:code) { GeoHelper.non_existent(:commune) }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 404 }
    # TODO: XXX le rattrapage des erreurs 404 est fait trop en amont pour qu'on puisse facilement customiser le message d'erreur...
    # its(:errors) { is_expected.to have_error('Le code INSEE commune n\'a pas été trouvé') }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  shared_examples 'valid code commune' do |code|
    subject { described_class.new(code).tap(&:perform) }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 200 }
    its(:errors) { is_expected.to be_empty }
  end

  GeoHelper.valid(:communes).each do |code|
    context "well formatted code #{code}", vcr: { cassette_name: "geo/commune/#{code}" } do
      it_behaves_like 'valid code commune', code
    end
  end
end
