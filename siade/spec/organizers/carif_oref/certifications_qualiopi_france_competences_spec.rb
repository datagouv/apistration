RSpec.describe CarifOref::CertificationsQualiopiFranceCompetences, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret: valid_siret(:carif_oref)
    }
  end

  describe 'valid params' do
    pending 'Implement endpoint'
  end
end
