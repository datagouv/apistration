require 'rails_helper'

RSpec.describe NomenclatureCoverageGuard do
  describe '.verify!' do
    subject(:verify) { described_class.verify!(request, response) }

    let(:request) do
      instance_double(
        ActionDispatch::Request,
        params: { 'controller' => 'api_particulier/v3_and_more/cnav/quotient_familial_with_civility', 'api_version' => '3' }
      )
    end

    let(:response) do
      ActionDispatch::TestResponse.new(status, { 'Content-Type' => 'application/vnd.api+json' }, [{ errors: [{ code: }] }.to_json])
    end

    let(:status) { 404 }

    context 'with a JSON:API error body carrying a code the operation documents' do
      let(:code) { '35003' }

      it { expect { verify }.not_to raise_error }
    end

    context 'with a JSON:API error body carrying a code the operation does not document' do
      let(:code) { '37003' }

      it { expect { verify }.to raise_error(/api_particulier_v3_cnav_quotient_familial_with_civility renders \["37003"\]/) }
    end

    context 'with a code the operation documents under another status' do
      let(:code) { '35003' }
      let(:status) { 502 }

      it { expect { verify }.to raise_error(/renders \["35003"\] with a 502/) }
    end
  end
end
