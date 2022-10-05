RSpec.describe BanqueDeFrance::BilansEntreprise::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with a valid siren', vcr: { cassette_name: 'banque_de_france/bilans_entreprises/valid_siren' } do
      let(:siren) { valid_siren(:bilan_entreprise_bdf) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
