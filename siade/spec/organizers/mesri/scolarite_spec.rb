RSpec.describe MESRI::Scolarite, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

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

    describe 'happy path', vcr: { cassette_name: 'mesri/scolarites/valid' } do
      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
