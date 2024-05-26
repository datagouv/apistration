RSpec.describe INPI::RNE::ActesBilans::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with a valid siren' do
      let(:siren) { valid_siren(:inpi) }

      before { stub_inpi_rne_actes_bilans_valid(siren:) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
