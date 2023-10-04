RSpec.describe CarifOref::CertificationsQualiopiFranceCompetences, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret: valid_siret(:carif_oref)
    }
  end

  context 'with a valid siret', vcr: { cassette_name: 'carif_oref/certifications_qualiopi_france_competences/valid_siret' } do
    let(:siret) { valid_siret(:carif_oref) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      expect(subject.bundled_data.data).to be_present
    end
  end
end
