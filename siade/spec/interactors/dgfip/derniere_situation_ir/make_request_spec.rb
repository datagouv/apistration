RSpec.describe DGFIP::DerniereSituationIR::MakeRequest, type: :make_request do
  subject { described_class.call(token:, params:) }

  let(:params) { { tax_number: } }

  describe '.call', vcr: { cassette_name: 'dgfip/derniere_situation_ir/valid_tax_number' } do
    let(:tax_number) { '1234567890ABC' }

    let(:token) do
      DGFIP::DerniereSituationIR::Authenticate.call.token
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
