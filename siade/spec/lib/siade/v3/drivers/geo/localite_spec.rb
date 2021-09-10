RSpec.describe SIADE::V3::Drivers::Geo::Localite, type: :provider_driver do
  subject { described_class.new(code_commune: code).perform_request }

  shared_examples 'bad code commune' do |code|
    let(:code) { code }

    its(:http_code) { is_expected.to eq 422 }
    its(:success?) { is_expected.to be_falsey }
    its(:errors) { is_expected.to have_error('Le code INSEE commune n\'est pas correctement formaté') }

    context 'commune nesting' do
      subject { super().commune }

      its([:code])  { is_expected.to be_nil }
      its([:value]) { is_expected.to be_nil }
    end

    context 'region nesting' do
      subject { super().region }

      its([:code])  { is_expected.to be_nil }
      its([:value]) { is_expected.to be_nil }
    end
  end

  it_behaves_like 'bad code commune', 'nope'
  it_behaves_like 'bad code commune', nil

  context 'code commune unknown', vcr: { cassette_name: 'geo/commune/non_existent' } do
    let(:code) { GeoHelper.non_existent(:commune) }

    its(:http_code) { is_expected.to eq 404 }
    its(:success?) { is_expected.to be_falsey }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }

    context 'commune nesting' do
      subject { super().commune }

      its([:code])  { is_expected.to be_nil }
      its([:value]) { is_expected.to be_nil }
    end

    context 'region nesting' do
      subject { super().region }

      its([:code])  { is_expected.to be_nil }
      its([:value]) { is_expected.to be_nil }
    end
  end

  context 'valid code commune', vcr: { cassette_name: 'geo/commune/76322' } do
    let(:code) { GeoHelper.valid(:communes).first }

    its(:http_code) { is_expected.to eq 200 }
    its(:success?) { is_expected.to be_truthy }
    its(:errors) { is_expected.to be_empty }

    context 'commune nesting' do
      subject { super().commune }

      its([:code])  { is_expected.to eq '76322' }
      its([:value]) { is_expected.to eq 'Le Grand-Quevilly' }
    end

    context 'region nesting' do
      subject { super().region }

      its([:code])  { is_expected.to eq '28' }
      its([:value]) { is_expected.to eq 'Normandie' }
    end
  end
end
