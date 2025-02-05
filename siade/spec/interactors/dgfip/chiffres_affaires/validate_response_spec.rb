RSpec.describe DGFIP::ChiffresAffaires::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'DGFIP - Adélie') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'with a json as body' do
      let(:body) { data.to_json }

      context 'when json is valid' do
        context 'when liste_ca is an array' do
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

          its(:cacheable) { is_expected.to be(true) }
        end

        context 'when liste_ca is a single element' do
          let(:data) do
            {
              'liste_ca' => {
                'ca' => '9001',
                'dateFinExercice' => '2016-12-31T00:00:00+01:00'
              }
            }
          end

          it { is_expected.to be_a_success }

          its(:errors) { is_expected.to be_empty }

          its(:cacheable) { is_expected.to be(true) }
        end

        context 'when liste_ca is empty' do
          let(:data) do
            {
              'liste_ca' => []
            }
          end

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

          its(:cacheable) { is_expected.to be(false) }
        end
      end

      context 'when json is not valid' do
        let(:data) do
          {
            'whatever' => 'ok'
          }
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        its(:cacheable) { is_expected.to be(false) }
      end
    end

    context 'with a body which is not a json' do
      context 'when body is empty string' do
        let(:body) { '' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        its(:cacheable) { is_expected.to be(false) }
      end

      context 'when body is "null" string' do
        let(:body) { 'null' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        its(:cacheable) { is_expected.to be(false) }
      end
    end
  end

  context 'with a 404 error' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a 204 error' do
    let(:response) { instance_double(Net::HTTPNoContent, code: '204') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a 500 runtime error' do
    let(:response) { instance_double(Net::HTTPInternalServerError, code: '500', body:) }
    let(:body) { '{"erreur":{"code":303001,"message":"Runtime Error","horodatage":"2025-02-05T09:39:22+01:00"}}' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderTemporaryError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

    its(:cacheable) { is_expected.to be(false) }
  end
end
