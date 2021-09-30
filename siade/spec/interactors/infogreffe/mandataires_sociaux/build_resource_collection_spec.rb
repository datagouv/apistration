RSpec.describe Infogreffe::MandatairesSociaux::BuildResourceCollection, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
    subject { described_class.call(response: response) }

    let(:valid_resource_pp) do
      {
        id: "#{valid_siren(:extrait_rcs)}-0",
        nom: 'HISQUIN',
        prenom: 'FRANCOIS',
        fonction: 'PRESIDENT DU DIRECTOIRE',
        date_naissance: '1965-01-27',
        date_naissance_timestamp: -155_523_600,
        raison_sociale: nil,
        identifiant: nil,
        type: 'PP'
      }
    end

    let(:valid_resource_pm) do
      {
        id: "#{valid_siren(:extrait_rcs)}-10",
        nom: nil,
        prenom: nil,
        fonction: 'COMMISSAIRE AUX COMPTES SUPPLEANT',
        date_naissance: nil,
        date_naissance_timestamp: nil,
        raison_sociale: 'BCRH & ASSOCIES - SOCIETE A RESPONSABILITE LIMITEE',
        identifiant: '490092574',
        type: 'PM'
      }
    end

    let(:response) do
      instance_double('Net::HTTPOK', body: body)
    end

    let(:body) do
      Infogreffe::MandatairesSociaux::MakeRequest.call(params: params).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:extrait_rcs)
      }
    end

    it { is_expected.to be_a_success }

    it 'builds valid resource collection' do
      expect(subject.resource_collection).to all(be_a(Resource))
    end

    it 'contain valid PPs' do
      expect(subject.resource_collection[0]).to have_attributes(valid_resource_pp)
    end

    it 'contain valid PMs' do
      expect(subject.resource_collection[10]).to have_attributes(valid_resource_pm)
    end
  end
end
