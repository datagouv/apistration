RSpec.describe MEN::Scolarites, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

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

    before do
      mock_men_scolarites_auth
      mock_men_scolarite
    end

    describe 'happy path' do
      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
