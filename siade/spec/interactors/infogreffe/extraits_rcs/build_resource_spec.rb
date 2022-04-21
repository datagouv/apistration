RSpec.describe Infogreffe::ExtraitsRCS::BuildResource, type: :build_resource do
  let(:instance) { described_class.call(params:, response:) }

  describe '.call', vcr: { cassette_name: 'infogreffe/extraits_rcs/with_valid_siren' } do
    subject { instance }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      Infogreffe::MakeRequest.call(params:).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:extrait_rcs)
      }
    end

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.resource }

      its(:id) { is_expected.to eq('418166096') }
      its(:date_immatriculation) { is_expected.to eq('1998-03-27') }
      its(:date_extrait) { is_expected.to eq('30 MAI 2017') }
      its(:observations) { is_expected.to be_an_instance_of(Array) }

      describe 'resource.observations entry' do
        subject(:observation) { instance.resource.observations[0] }

        it { expect(observation[:numero]).to eq('12197') }
        it { expect(observation[:libelle]).to eq('LA SOCIETE NE CONSERVE AUCUNE ACTIVITE A SON ANCIEN SIEGE') }
        it { expect(observation[:date]).to eq('2000-02-23') }
      end
    end
  end
end
