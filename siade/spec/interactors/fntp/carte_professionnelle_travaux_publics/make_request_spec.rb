RSpec.describe FNTP::CarteProfessionnelleTravauxPublics::MakeRequest, type: :make_request do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siren: siren
    }
  end

  context 'when the siren is valid and renders a valid response', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/valid_siren' } do
    let(:siren) { valid_siren(:fntp) }

    it { is_expected.to be_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
