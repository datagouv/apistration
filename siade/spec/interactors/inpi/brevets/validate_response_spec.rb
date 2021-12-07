RSpec.describe INPI::Brevets::ValidateResponse, type: :validate_response do
  subject { described_class.call(response: response, provider_name: 'INPI') }

  let(:response) do
    instance_double('Net::HTTPOK', code: code, body: body)
  end

  describe 'with a valid body' do
    let(:body) do
      {
        results: [{
          fields: [
            {
              name: 'PUBN',
              value: '<country>FR</country><doc-number>3110115</doc-number><kind>A1</kind>'
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
      let(:code) { '200' }
      let(:body) { 'Nonsense' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end
  end
end
