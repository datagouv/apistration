RSpec.describe PROBTP::AttestationsCotisationsRetraite::MakeRequest do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:
      }
    end

    context 'with a well formatted siret' do
      context 'when the siret is eligible for the attestation' do
        let(:siret) { eligible_siret(:probtp) }

        before { stub_probtp_attestation_eligible }

        it { is_expected.to be_success }

        its(:response) { is_expected.to be_a(Net::HTTPOK) }
      end
    end
  end
end
