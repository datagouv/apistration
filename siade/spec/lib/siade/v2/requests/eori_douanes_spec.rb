RSpec.describe SIADE::V2::Requests::EORIDouanes, type: :provider_request do
  subject { described_class.new({ eori: eori }).perform }

  let(:payload) { JSON.parse(subject.response.body, symbolize_names: true) }

  describe 'invalid EORI' do
    shared_examples 'invalid EORI' do
      its(:http_code) { is_expected.to eq 422 }
      its(:errors) { is_expected.to have_error('Le numéro de siret ou le numéro EORI n\'est pas correctement formatté') }
    end

    context 'when EORI does not respect the UE format (does not start with letters)' do
      let(:eori) { "__#{valid_siret}" }

      it_behaves_like 'invalid EORI'
    end

    context 'when foreign EORI contains whitespaces' do
      let(:eori) { "\t\r\n#{valid_spanish_eori}" }

      it_behaves_like 'invalid EORI'
    end

    context 'when EORI contains whitespaces' do
      let(:eori) { "\t\r\n#{valid_eori}" }

      it_behaves_like 'invalid EORI'
    end

    context 'when EORI suffix is not a SIRET' do
      let(:eori) { invalid_eori }

      it_behaves_like 'invalid EORI'
    end
  end

  describe 'success' do
    # TODO: test "operateur tiers ?!"
    context 'with french EORI', vcr: { cassette_name: 'douanes/eori/valid_eori' } do
      let(:eori) { valid_eori }

      its(:http_code) { is_expected.to eq 200 }
      its(:errors) { is_expected.to be_empty }
      it { expect(payload).to have_key(:EORI) }
    end

    context 'with spanish EORI', vcr: { cassette_name: 'douanes/eori/valid_spanish_eori' } do
      let(:eori) { valid_spanish_eori }

      its(:http_code) { is_expected.to eq 200 }
      its(:errors) { is_expected.to be_empty }
      it { expect(payload).to have_key(:EORI) }
    end
  end
end
