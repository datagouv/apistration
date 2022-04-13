RSpec.describe OPQIBI::CertificationsIngenierie, type: :retriever_organizer do
  subject { described_class.call(params:) }

  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with valid siren', vcr: { cassette_name: 'opqibi/certifications_ingenierie/valid_siren' } do
      let(:siren) { valid_siren(:opqibi_with_probatoire) }

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_present }
    end
  end
end
