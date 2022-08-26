RSpec.describe CNOUS::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'MESRI', params_kind: 'ine') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    context 'with a valid code' do
      let(:code) { '200' }

      context 'with data in payload' do
        let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_valid_response.json')) }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'with invalid body' do
        let(:body) { 'lol' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end

    context 'with a 404 code' do
      let(:response) do
        instance_double(Net::HTTPNotFound, code:, body:)
      end

      let(:code) { '404' }

      let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_not_found.json')) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a 400 code' do
      let(:response) do
        instance_double(Net::HTTPBadRequest, code:, body:)
      end

      let(:code) { '400' }
      let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_bad_request.json')) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
