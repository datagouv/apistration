RSpec.describe SIADE::V2::Requests::INSEE::Etablissement, type: :provider_request do
  subject { described_class.new(siret).tap(&:perform) }

  before { allow_any_instance_of(RenewINSEETokenService).to receive(:current_token_expired?).and_return(false) }

  it 'try to renew INSEE token', vcr: { cassette_name: 'api_insee_fr/siret/active_GE' } do
    expect_any_instance_of(RenewINSEETokenService).to receive(:call).once
    described_class.new(sirets_insee_v3[:active_GE]).tap(&:perform)
  end

  context 'bad formated siret' do
    let(:siret) { invalid_siret }

    its(:valid?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'non-existent siret', vcr: { cassette_name: 'api_insee_fr/siret/non_existent' } do
    let(:siret) { non_existent_siret }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 404 }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  context 'when siret is non diffusible even for us...' do
    shared_examples 'confidential siret returns 451' do |type|
      let(:siret) { confidential_siret(type) }

      its(:valid?) { is_expected.to be_truthy }
      its(:http_code) { is_expected.to eq 451 }
      its(:errors) { is_expected.to have_error('Le siren ou siret demandé est une entité pour laquelle aucun organisme ne peut avoir accès.') }
    end

    describe 'entrepreneur individuel ceased', vcr: { cassette_name: 'api_insee_fr/siret/non_diffusable_ceased' } do
      it_behaves_like 'confidential siret returns 451', :non_diffusable_ceased
    end

    describe 'gendarmerie Limousin', vcr: { cassette_name: 'api_insee_fr/siret/gendarmerie_limousin' } do
      it_behaves_like 'confidential siret returns 451', :gendarmerie_limousin
    end
  end

  shared_examples 'valid request INSEE' do |siret|
    subject { described_class.new(siret).tap(&:perform) }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 200 }
    its(:errors) { is_expected.to be_empty }
  end

  sirets_insee_v3.each do |label, siret|
    context "well formated #{label}: #{siret}", vcr: { cassette_name: "api_insee_fr/siret/#{label}" } do
      it_behaves_like 'valid request INSEE', siret
    end
  end
end
