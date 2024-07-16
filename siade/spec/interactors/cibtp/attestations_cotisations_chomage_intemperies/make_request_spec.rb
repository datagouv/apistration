RSpec.describe CIBTP::AttestationsCotisationsChomageIntemperies::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:
      }
    end

    context 'with a valid siret' do
      before { stub_cibtp_attestations_cotisations_chomage_intemperies_valid(siret:) }

      let(:siret) { valid_siret }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
