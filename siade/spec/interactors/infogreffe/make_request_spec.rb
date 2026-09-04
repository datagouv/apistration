RSpec.describe Infogreffe::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren: valid_siren(:extrait_rcs)
    }
  end

  describe 'happy path' do
    let(:siren) { siren }

    before { stub_infogreffe_personne_morale }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
