RSpec.describe DGFIP::LiensCapitalistiques::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'when body contains at least 2059F or 2059G imprime' do
      let(:body) do
        {
          declarations: [
            {
              numero_imprime: %w[2059F 2059G].sample
            }
          ]
        }.to_json
      end

      it { is_expected.to be_a_success }
    end

    context 'when body contains neither 2059F nor 2059G imprime' do
      let(:body) do
        {
          declarations: [
            {
              numero_imprime: '2058C'
            }
          ]
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      its(:cacheable) { is_expected.to be(true) }
    end

    context 'when body is an HTML error page (inherited from LiassesFiscales validator)' do
      let(:body) { read_payload_file('dgfip/liasses_fiscales/server_error.html') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
      its(:cacheable) { is_expected.to be(false) }
    end
  end
end
