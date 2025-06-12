RSpec.describe MESRI::StudentStatus::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'MESRI') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    context 'with a valid code' do
      let(:code) { '200' }

      context 'with data in payload' do
        context 'when it is with ine param' do
          let(:body) { read_payload_file('mesri/student_status/with_ine_valid_response.json') }

          it { is_expected.to be_a_success }

          its(:errors) { is_expected.to be_empty }
        end

        context 'when it is with civility params' do
          let(:body) { read_payload_file('mesri/student_status/with_civility_valid_response.json') }

          it { is_expected.to be_a_success }

          its(:errors) { is_expected.to be_empty }
        end
      end

      context 'with invalid body' do
        let(:body) { 'lol' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end

      context "with a 'null' body" do
        let(:body) { 'null' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end

    context 'with a 404 code' do
      let(:response) do
        instance_double(Net::HTTPNotFound, code:, body:)
      end

      let(:code) { '404' }

      context 'when it is with ine param' do
        let(:body) { read_payload_file('mesri/student_status/with_ine_not_found_response.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'when it is with civility params' do
        let(:body) { read_payload_file('mesri/student_status/with_civility_not_found_response.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end

    context 'with a 400 code' do
      let(:response) do
        instance_double(Net::HTTPBadRequest, code:, body:)
      end

      let(:code) { '400' }
      let(:body) { read_payload_file('mesri/student_status/with_ine_invalid_ine_response.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
