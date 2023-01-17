RSpec.describe MESRI::Scolarite::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, access_token:) }

    let(:access_token) { 'correct-auth-token' }

    context 'with valid params', vcr: { cassette_name: 'mesri/scolarite/valid' } do
      let(:params) do
        {
          nom: 'COULEARD',
          prenom: 'cecile',
          sexe: '2',
          date_naissance: '2000-06-10',
          code_etablissement: '0511474A',
          annee_scolaire: '2021'
        }
      end

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
