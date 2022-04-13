RSpec.describe OPQIBI::CertificationsIngenierie::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with a valid siren', vcr: { cassette_name: 'opqibi/certifications_ingenierie/valid_siren' } do
      let(:siren) { valid_siren(:opqibi_with_probatoire) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
