RSpec.describe Douanes::EORI::MakeRequest, type: :make_request do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      siret_or_eori: eori
    }
  end

  describe 'happy path', vcr: { cassette_name: 'douanes/eori/valid_eori' } do
    let(:eori) { valid_eori }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
