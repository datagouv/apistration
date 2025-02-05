RSpec.describe CNOUS::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'MESRI', params: { ine: 'dummy ine' }) }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    context 'with a valid code' do
      let(:code) { '200' }

      context 'with valid data' do
        context 'when data is a single element (from INE endpoint)' do
          let(:body) { cnous_valid_payload('ine').to_json }

          it { is_expected.to be_a_success }

          its(:errors) { is_expected.to be_empty }
        end

        context 'when data is an array (from civility endpoint)' do
          context 'when there is only one element' do
            let(:body) { cnous_valid_payload('civility').to_json }

            it { is_expected.to be_a_success }

            its(:errors) { is_expected.to be_empty }
          end

          context 'when there are multiple elements' do
            let(:body) do
              [
                read_payload_file('cnous/student_scholarship_valid_response.json'),
                read_payload_file('cnous/student_scholarship_valid_response.json')
              ].to_json
            end

            it { is_expected.to be_a_failure }

            its(:errors) { is_expected.to include(instance_of(ProviderConflictError)) }

            it 'captures error in monitoring' do
              expect(MonitoringService.instance).to receive(:track_with_added_context).with(
                'error',
                anything,
                { ine: 'dummy ine' }
              )

              call
            end
          end
        end
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

      let(:body) { read_payload_file('cnous/student_scholarship_not_found.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a 400 code' do
      let(:response) do
        instance_double(Net::HTTPBadRequest, code:, body:)
      end

      let(:code) { '400' }
      let(:body) { read_payload_file('cnous/student_scholarship_bad_request.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with a 500 code' do
      let(:response) do
        instance_double(Net::HTTPInternalServerError, code:)
      end

      let(:code) { '500' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end
  end
end
