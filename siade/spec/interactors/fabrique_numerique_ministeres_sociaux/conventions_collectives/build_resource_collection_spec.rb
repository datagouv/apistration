RSpec.describe FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::BuildResourceCollection, type: :build_resource do
  subject(:call) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest.call(params:).response.body
  end

  let(:params) do
    {
      siret:
    }
  end

  let(:siret) { valid_siret(:conventions_collectives) }

  context 'when siret is valid', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'builds valid resource items' do
      expect(resource_collection.first.to_h).to eq(
        {
          id: 'ANONYME000001234567',
          numero_idcc: 9876,
          titre: 'Convention collective des bureaux de conseil en ingénierie du 28 février 2001.',
          titre_court: 'Conseil en ingénierie industrielle et consulting technique',
          active: true,
          etat: 'vigueur',
          url: 'https://www.legifrance.gouv.fr/affichIDCC.do?idConvention=ANONYME000001234567',
          synonymes: ['anonyme'],
          date_publication: '2001-05-15'
        }
      )
    end
  end

  context 'with one missing publication date' do
    let(:body) do
      read_payload_file('fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_with_missing_date_publication.json')
    end

    it { is_expected.to be_a_success }
  end
end
