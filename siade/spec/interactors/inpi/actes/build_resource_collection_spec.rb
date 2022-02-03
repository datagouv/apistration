RSpec.describe INPI::Actes::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'inpi/actes/with_valid_siren' } do
    subject(:call) { described_class.call(response: response, params: params) }

    let(:valid_collection) do
      [
        {
          id: 12_350_131,
          siren: 542_065_479,
          code_greffe: 1234,
          date_depot: '2017-01-13',
          nature_archive: 'A'
        },
        {
          id: 1_231_419,
          siren: 542_065_479,
          code_greffe: 1234,
          date_depot: '2015-01-13',
          nature_archive: 'P'
        }
      ]
    end

    let(:response) do
      instance_double('Net::HTTPOK', body: body)
    end

    let(:body) do
      INPI::Actes::MakeRequest.call(params: params, cookie: valid_cookie_inpi).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:inpi)
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resources' do
      expect(call.resource_collection).to all be_a(Resource)
    end

    it 'has right number of resources' do
      expect(call.resource_collection.count).to eq(3)
    end

    it 'has valid resource_collection' do
      expect(call.resource_collection.first(2).map(&:to_h)).to eq(valid_collection)
    end
  end
end
