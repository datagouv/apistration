RSpec.describe PROBTP::ConformitesCotisationsRetraite::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siret: siret
      }
    end

    context 'with a well formatted siret' do
      context 'when the siret is ok', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_eligible_siret' } do
        let(:siret) { eligible_siret(:probtp) }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end

      context 'when the siret is not ok', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_non_eligible_siret' } do
        let(:siret) { non_eligible_siret(:probtp) }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end

      context 'when the siret is not found', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_not_found_siret' } do
        let(:siret) { valid_siret(:octo) }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end
    end
  end
end
