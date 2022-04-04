RSpec.describe CNETP::AttestationCotisationsCongesPayesChomageIntemperies::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'when the siren is valid and renders a valid response', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/valid_siren' } do
    let(:siren) { valid_siren(:cnetp) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end

  context 'when the siren is valid and renders a not found response', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/not_found_siren' } do
    let(:siren) { not_found_siren }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPNotFound) }
  end
end
