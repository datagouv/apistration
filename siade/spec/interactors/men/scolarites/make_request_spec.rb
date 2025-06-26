RSpec.describe MEN::Scolarites::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, token:, recipient:) }

    let(:token) { 'jwt-access-token' }
    let(:recipient) { nil }
    let(:params) do
      {
        nom_naissance: 'NOMFAMILLE',
        prenoms: ['prenom'],
        sexe_etat_civil: 'f',
        jour_date_naissance: '10',
        mois_date_naissance: '06',
        annee_date_naissance: '2000',
        code_etablissement: '0511474A',
        annee_scolaire: '2021',
        provider_api_version: 'v1'
      }
    end

    it_behaves_like 'a make request with working mocking_params'

    context 'with valid params', vcr: { cassette_name: 'men/scolarites/valid' } do
      let(:params) do
        {
          nom_naissance: 'NOMFAMILLE',
          prenoms: ['prenom'],
          sexe_etat_civil: 'f',
          jour_date_naissance: '10',
          mois_date_naissance: '06',
          annee_date_naissance: '2000',
          code_etablissement: '0511474A',
          annee_scolaire: '2021',
          provider_api_version: 'v1'
        }
      end

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end

    context 'with a sexe_etat_civil upcased (non-regression test)', vcr: { cassette_name: 'men/scolarites/valid' } do
      let(:params) do
        {
          nom_naissance: 'NOMFAMILLE',
          prenoms: ['prenom'],
          sexe_etat_civil: 'F',
          jour_date_naissance: '10',
          mois_date_naissance: '06',
          annee_date_naissance: '2000',
          code_etablissement: '0511474A',
          annee_scolaire: '2021',
          provider_api_version: 'v1'
        }
      end

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end

    context 'with a sexe_etat_civil upcased (non-regression test)', vcr: { cassette_name: 'men/scolarites/valid_v2' } do
      let(:recipient) { '13002526500013' }
      let(:params) do
        {
          nom_naissance: 'NOMFAMILLE',
          prenoms: ['prenom'],
          sexe_etat_civil: 'F',
          jour_date_naissance: '10',
          mois_date_naissance: '06',
          annee_date_naissance: '2000',
          code_etablissement: '0511474A',
          annee_scolaire: '2021',
          provider_api_version: 'v2'
        }
      end

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
