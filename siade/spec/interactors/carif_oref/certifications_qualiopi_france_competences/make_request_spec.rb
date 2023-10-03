RSpec.describe CarifOref::CertificationsQualiopiFranceCompetences::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:
      }
    end

    context 'with a valid siret', vcr: { cassette_name: 'carif_oref/certifications_qualiopi_france_competences/valid_siret' } do
      let(:siret) { valid_siret(:carif_oref) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end

    context 'with a siret without data', vcr: { cassette_name: 'carif_oref/certifications_qualiopi_france_competences/no_data' } do
      let(:siret) { not_found_siret }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
