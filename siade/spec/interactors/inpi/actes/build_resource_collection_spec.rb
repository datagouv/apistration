RSpec.describe INPI::Actes::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'inpi/actes/with_valid_siren' } do
    subject(:call) { described_class.call(response:, params:) }

    let(:valid_collection) do
      [
        {
          id: 12_350_131,
          siren: '542065479',
          code_greffe: 1234,
          date_depot: '2017-01-13',
          nature_archive: 'A',
          greffe_url: 'https://opendata.datainfogreffe.fr/api/records/1.0/search/?dataset=liste-des-greffes&q=code_greffe%3D1234&facet=greffe&rows=1'
        },
        {
          id: 1_231_419,
          siren: '542065479',
          code_greffe: 1234,
          date_depot: '2015-01-13',
          nature_archive: 'P',
          greffe_url: 'https://opendata.datainfogreffe.fr/api/records/1.0/search/?dataset=liste-des-greffes&q=code_greffe%3D1234&facet=greffe&rows=1'
        }
      ]
    end

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      INPI::Actes::MakeRequest.call(params:, cookie: valid_cookie_inpi).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:inpi)
      }
    end

    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(resource_collection).to all be_a(Resource)
    end

    it 'has right number of resources' do
      expect(resource_collection.count).to eq(3)
    end

    it 'has valid resource_collection' do
      expect(resource_collection.first(2).map(&:to_h)).to eq(valid_collection)
    end
  end
end
