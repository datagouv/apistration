RSpec.describe RNM::EntreprisesArtisanales::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with a valid siren' do
      let(:siren) { valid_siren(:rnm_cma) }

      before { stub_rnm_valid_siren }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
