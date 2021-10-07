RSpec.describe Infogreffe::MandatairesSociaux::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
    subject { described_class.call(response: response) }

    let(:valid_pp) do
      {
        nom: 'HISQUIN',
        prenom: 'FRANCOIS',
        fonction: 'PRESIDENT DU DIRECTOIRE',
        date_naissance: '1965-01-27',
        date_naissance_timestamp: -155_523_600
      }
    end
    let(:valid_pm) do
      {
        fonction: 'COMMISSAIRE AUX COMPTES TITULAIRE',
        raison_sociale: 'MAZARS - SOCIETE ANONYME',
        identifiant: '784824153'
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

    it 'builds valid resource' do
      expect(subject.resource).to be_a(Resource)
    end

    it 'contain valid PPs' do
      expect(subject.resource.pp.first).to eq(valid_pp)
    end

    it 'contain valid PMs' do
      expect(subject.resource.pm.first).to eq(valid_pm)
    end
  end
end
