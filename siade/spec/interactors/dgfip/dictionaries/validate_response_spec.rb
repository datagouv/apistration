RSpec.describe DGFIP::Dictionaries::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:) }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'with a valid json body' do
      let(:body) { read_payload_file('dgfip/dictionary.json') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }

      its(:cacheable) { is_expected.to be(true) }
    end

    context 'with a body which is not a json' do
      context 'with an empty body' do
        let(:body) { nil }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        its(:cacheable) { is_expected.to be(false) }
      end
    end
  end

  context 'with an http not ok' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

    its(:cacheable) { is_expected.to be(false) }
  end
end
