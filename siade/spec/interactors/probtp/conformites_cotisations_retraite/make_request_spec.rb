RSpec.describe PROBTP::ConformitesCotisationsRetraite::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:
      }
    end

    context 'with a well formatted siret' do
      context 'when the siret is ok' do
        let(:siret) { eligible_siret(:probtp) }

        before { stub_probtp_conformite_eligible }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end

      context 'when the siret is not ok' do
        let(:siret) { non_eligible_siret(:probtp) }

        before { stub_probtp_conformite_non_eligible }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end

      context 'when the siret is not found' do
        let(:siret) { valid_siret(:octo) }

        before { stub_probtp_conformite_not_found(siret: valid_siret(:octo)) }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end
    end
  end
end
