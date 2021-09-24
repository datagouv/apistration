RSpec.describe Infogreffe::MandatairesSociaux::MakeRequest, type: :make_request do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siren: valid_siren(:extrait_rcs)
    }
  end

  describe 'happy path', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
    let(:siren) { siren }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
