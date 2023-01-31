RSpec.describe Infogreffe::MandatairesSociaux::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:, provider_name: 'Infogreffe') }

    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body:)
    end

    context 'with a valid payload' do
      let(:body) { open_payload_file('infogreffe/without_personne_physique_naissance.xml').read }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with a payload with has no mandataires sociaux' do
      let(:body) { open_payload_file('infogreffe/without_mandataire.xml').read }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end
  end
end
