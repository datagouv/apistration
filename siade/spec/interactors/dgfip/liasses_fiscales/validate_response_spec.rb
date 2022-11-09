RSpec.describe DGFIP::LiassesFiscales::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, code:, body:) }

    context 'when status is 200' do
      let(:code) { 200 }

      context 'when body is a valid json' do
        let(:body) do
          {
            declarations: []
          }.to_json
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }

        its(:cacheable) { is_expected.to be(true) }
      end

      context 'when body is not a valid json' do
        let(:body) { 'whatever' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        its(:cacheable) { is_expected.to be(false) }
      end
    end

    context 'when http status is a 404' do
      let(:code) { 404 }
      let(:body) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(DGFIPPotentialNotFoundError)) }

      its(:cacheable) { is_expected.to be(true) }
    end

    context 'when http status is a 503' do
      let(:code) { 503 }
      let(:body) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }

      its(:cacheable) { is_expected.to be(false) }
    end

    context 'when http status is another error' do
      let(:code) { 403 }
      let(:body) { '' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

      its(:cacheable) { is_expected.to be(false) }
    end
  end
end
