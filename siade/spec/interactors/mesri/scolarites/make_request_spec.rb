RSpec.describe MESRI::Scolarites::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, token:) }

    let(:token) { 'jwt-access-token' }

    context 'with valid params', vcr: { cassette_name: 'mesri/scolarites/valid' } do
      let(:params) do
        {
          family_name: 'NOMFAMILLE',
          first_name: 'prenom',
          gender: 'f',
          birth_date: '2000-06-10',
          code_etablissement: '0511474A',
          annee_scolaire: '2021'
        }
      end

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
