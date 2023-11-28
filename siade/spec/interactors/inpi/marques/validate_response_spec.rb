RSpec.describe INPI::Marques::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'INPI') }

  let(:response) do
    instance_double(Net::HTTPOK, code:, body:)
  end

  describe 'with a valid body' do
    let(:body) do
      {
        results: [{
          documentId: 'id',
          fields: [
            {
              name: 'field name',
              value: 'field value'
            },
            {
              name: 'ApplicationNumber',
              value: 'field value'
            }
          ]
        }]
      }.to_json
    end

    context 'with an invalid code' do
      let(:code) { '500' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with a valid code' do
      let(:code) { '200' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end

  describe 'with a valid code' do
    let(:code) { '200' }

    context 'with a body with no results' do
      let(:body) do
        {
          results: []
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'with a body containing nonsense' do
      let(:body) { 'Nonsense' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with an element without ApplicationNumber field' do
      let(:body) do
        {
          results: [{
            documentId: 'id',
            fields: [
              {
                name: 'field name',
                value: 'field value'
              }
            ]
          }]
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with an element without documentId' do
      let(:body) do
        {
          results: [{
            fields: [
              {
                name: 'field name',
                value: 'field value'
              },
              {
                name: 'ApplicationNumber',
                value: '1234'
              }
            ]
          }]
        }.to_json
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end
end
