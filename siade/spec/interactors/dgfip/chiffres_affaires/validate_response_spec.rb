RSpec.describe DGFIP::ChiffresAffaires::ValidateResponse, type: :validate_response do
  subject { described_class.call(response: response, provider_name: 'DGFIP') }

  context 'with a http ok' do
    let(:response) { instance_double('Net::HTTPOK', code: '200', body: body) }

    context 'with a json as body' do
      let(:body) { data.to_json }

      context 'when json is valid' do
        let(:data) do
          {
            'liste_ca' => [
              {
                'ca' => '9001',
                'dateFinExercice' => '2016-12-31T00:00:00+01:00'
              },
              {
                'ca' => '425169',
                'dateFinExercice' => '2015-12-31T00:00:00+01:00'
              }
            ]
          }
        end

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when json is not valid' do
        let(:data) do
          {
            'whatever' => 'ok'
          }
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end
    end

    context 'with a body which is not a json' do
      context 'when body is empty string' do
        let(:body) { '' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end

      context 'when body is "null" string' do
        let(:body) { 'null' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end
  end

  context 'with an unknown error' do
    let(:response) { instance_double('Net::HTTPBadRequest', code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
