RSpec.describe FNTP::CarteProfessionnelleTravauxPublics::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'when the siren is valid and renders a valid response' do
    let(:siren) { valid_siren(:fntp) }

    before { stub_fntp_valid_siren }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
