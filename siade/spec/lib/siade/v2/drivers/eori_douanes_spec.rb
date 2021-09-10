RSpec.describe SIADE::V2::Drivers::EORIDouanes, type: :provider_driver do
  subject { described_class.new(eori: eori).perform_request }

  context 'when EORI is not found', vcr: { cassette_name: 'eori/non_existing_eori' } do
    let(:eori) { non_existing_eori }

    its(:http_code) { is_expected.to eq 404 }
  end

  context 'when EORI is found' do
    describe 'with french EORI', vcr: { cassette_name: 'eori/valid_eori' } do
      let(:eori) { valid_eori }

      its(:numero_eori) { is_expected.to eq valid_eori }
      its(:actif) { is_expected.to eq true }
      its(:raison_sociale) { is_expected.to eq 'CENTRE INFORMATIQUE DOUANIER' }
      its(:rue) { is_expected.to eq '27 R DES BEAUX SOLEILS' }
      its(:code_postal) { is_expected.to eq '95520' }
      its(:ville) { is_expected.to eq 'OSNY' }
      its(:pays) { is_expected.to eq 'FRANCE' }
      its(:code_pays) { is_expected.to eq 'FR' }
    end
  end
end
