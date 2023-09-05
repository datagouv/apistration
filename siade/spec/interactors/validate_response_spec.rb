RSpec.describe ValidateResponse do
  subject { DummyValidateResponse.call(params:, response:) }

  before(:all) do
    class DummyValidateResponse < ValidateResponse
      protected

      def call
        case response.code
        when '500'
          unknown_provider_response!
        end
      end

      def provider_name
        'INSEE'
      end
    end
  end

  let(:params) do
    {
      key: 'value'
    }
  end

  context 'with a OK response' do
    let(:response) { instance_double(Net::HTTPOK, code: '200') }

    it { is_expected.to be_a_success }
  end
end
