RSpec.describe GIPMDS::ServiceCivique::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'GIP-MDS') }

  let(:response) { instance_double(Net::HTTPOK, code:, body:) }
  let(:code) { '200' }
  let(:body) { read_payload_file('gip_mds/service_civique/valid.json') }

  context 'with a successful response containing one contract' do
    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with multiple contracts' do
    let(:body) { read_payload_file('gip_mds/service_civique/multiple_contracts.json') }

    it { is_expected.to be_a_success }

    it 'logs a warning to monitoring service' do
      expect(MonitoringService.instance).to receive(:track).with(
        'warning',
        'GIPMDS::ServiceCivique: individual has multiple service civique contracts'
      )

      subject
    end
  end

  context 'with NOT_FOUND_INDIVIDU response' do
    let(:code) { '404' }
    let(:body) { read_payload_file('gip_mds/service_civique/not_found.json') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with NOT_FOUND_CONTRAT response' do
    let(:code) { '404' }
    let(:body) { read_payload_file('gip_mds/service_civique/not_found_contrat.json') }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'with an unknown error' do
    let(:code) { '400' }
    let(:body) { ''.to_json }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a 500 error' do
    let(:code) { '500' }
    let(:body) { '' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with a 200 but missing individu key' do
    let(:body) { { 'other_key' => 'value' }.to_json }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
