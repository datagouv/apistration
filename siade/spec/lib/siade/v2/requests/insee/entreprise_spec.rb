RSpec.describe SIADE::V2::Requests::INSEE::Entreprise, type: :provider_request do
  subject { described_class.new(siren).tap(&:perform) }

  before { allow_any_instance_of(RenewINSEETokenService).to receive(:current_token_expired?).and_return(false) }

  it 'try to renew INSEE token', vcr: { cassette_name: 'insee/siren/active_GE' } do
    expect_any_instance_of(RenewINSEETokenService).to receive(:call).once
    described_class.new(sirens_insee_v3[:active_GE]).tap(&:perform)
  end

  context 'bad formated siren' do
    let(:siren) { invalid_siren }

    its(:valid?) { is_expected.to be_falsey }
    its(:http_code) { is_expected.to eq 422 }
    its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
  end

  context 'non-existent siren', vcr: { cassette_name: 'insee/siren/non_existent' } do
    let(:siren) { non_existent_siren }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 404 }
    its(:errors) { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu ou ne comporte aucune information pour cet appel') }
  end

  context 'when siren is non diffusible even for us...' do
    shared_examples 'confidential siren returns 451' do |type|
      let(:siren) { confidential_siren(type) }

      its(:valid?) { is_expected.to be_truthy }
      its(:http_code) { is_expected.to eq 451 }
      its(:errors) { is_expected.to have_error('Le siren ou siret demandé est une entité pour laquelle aucun organisme ne peut avoir accès.') }
    end

    describe 'entrepreneur individuel ceased', vcr: { cassette_name: 'insee/siren/non_diffusable_ceased' } do
      it_behaves_like 'confidential siren returns 451', :non_diffusable_ceased
    end

    describe 'gendarmerie Limousin', vcr: { cassette_name: 'insee/siren/gendarmerie_limousin' } do
      it_behaves_like 'confidential siren returns 451', :gendarmerie_limousin
    end
  end

  shared_examples 'valid request INSEE' do |siren|
    subject { described_class.new(siren).tap(&:perform) }

    its(:valid?) { is_expected.to be_truthy }
    its(:http_code) { is_expected.to eq 200 }
    its(:errors) { is_expected.to be_empty }
  end

  sirens_insee_v3.each do |label, siren|
    context "well formated #{label}: #{siren}", vcr: { cassette_name: "insee/siren/#{label}" } do
      it_behaves_like 'valid request INSEE', siren
    end
  end

  #  context 'debug', vcr: { cassette_name: 'insee/siren/active_AE' } do
  #    it_behaves_like 'valid request INSEE', sirens_insee_v3[:ceased_AE]
  #  end
end
