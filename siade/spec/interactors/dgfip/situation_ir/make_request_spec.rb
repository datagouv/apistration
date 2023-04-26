RSpec.describe DGFIP::SituationIR::MakeRequest, type: :make_request do
  subject { described_class.call(token:, params:) }

  let(:params) { { tax_number:, tax_notice_number: } }

  describe '.call', vcr: { cassette_name: 'dgfip/situation_ir/valid' } do
    let(:tax_number) { valid_tax_number }
    let(:tax_notice_number) { valid_tax_notice_number }

    let(:token) do
      DGFIP::SituationIR::Authenticate.call.token
    end

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
