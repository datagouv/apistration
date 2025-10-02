RSpec.describe Qualifelec::Certificats, type: :organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:
    }
  end

  before do
    stub_qualifelec_auth_success
  end

  context 'when siret is valid' do
    before do
      stub_qualifelec_certificates
    end

    let(:siret) { valid_siret(:qualifelec) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end

  context 'when siret is not found' do
    before do
      stub_qualifelec_404
    end

    let(:siret) { not_found_siret }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'when siren is found but has no certificates' do
    before do
      stub_qualifelec_no_certificates
    end

    let(:siret) { not_found_siret }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end
end
