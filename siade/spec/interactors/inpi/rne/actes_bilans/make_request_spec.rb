RSpec.describe INPI::RNE::ActesBilans::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:siren) { valid_siren(:inpi) }
    let(:params) do
      {
        siren:
      }
    end

    it_behaves_like 'a make request with working mocking_params'

    context 'with a valid siren' do
      before { stub_inpi_rne_actes_bilans_valid(siren:) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
