RSpec.describe DGDDI::EORI::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret_or_eori: eori
    }
  end

  describe 'happy path' do
    let(:eori) { valid_eori }

    before { stub_dgddi_valid_eori }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
