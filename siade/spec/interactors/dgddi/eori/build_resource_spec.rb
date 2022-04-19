RSpec.describe DGDDI::EORI::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'dgddi/eori/valid_eori' } do
    subject(:call) { described_class.call(response:) }

    let(:valid_payload) do
      {
        id: 'FR16002307300010',
        actif: true,
        code_pays: 'FR',
        code_postal: '95520',
        libelle: 'CENTRE INFORMATIQUE DOUANIER',
        pays: 'FRANCE',
        rue: '27 R DES BEAUX SOLEILS',
        ville: 'OSNY'
      }
    end

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      DGDDI::EORI::MakeRequest.call(params:).response.body
    end

    let(:params) do
      {
        siret_or_eori: valid_eori
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(call.resource).to be_a(Resource)
    end

    it 'has valid payload' do
      expect(call.resource.to_h).to eq(valid_payload)
    end
  end
end
