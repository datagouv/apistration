RSpec.describe CNETP::AttestationCotisationsCongesPayesChomageIntemperies::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'when the siren is valid and renders a valid response' do
    let(:siren) { valid_siren(:cnetp) }

    before { stub_cnetp_valid_siren }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when the siren is valid and renders a not found response' do
    let(:siren) { not_found_siren }

    before { stub_cnetp_not_found_siren }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end
end
