RSpec.describe SIADE::V2::Retrievers::ExtraitCourtINPI do
  describe 'drivers should delegate methods' do
    subject { described_class.new(valid_siren(:inpi)) }

    context 'driver modeles' do
      it 'should get info from driver brevets' do
        expect(subject.driver_brevets).to receive(:count)
        expect(subject.driver_brevets).to receive(:latests_brevets)
        subject.count_brevets
        subject.latests_brevets
      end

      it 'should get info from driver modeles' do
        expect(subject.driver_modeles).to receive(:count)
        expect(subject.driver_modeles).to receive(:latests_modeles)
        subject.count_modeles
        subject.latests_modeles
      end

      it 'should get info from driver marques' do
        expect(subject.driver_marques).to receive(:count)
        expect(subject.driver_marques).to receive(:latests_marques)
        subject.count_marques
        subject.latests_marques
      end
    end
  end

  describe 'http code' do
    before do
      allow_any_instance_of(SIADE::V2::Drivers::BrevetsINPI).to receive(:http_code).and_return(200)
      allow_any_instance_of(SIADE::V2::Drivers::ModelesINPI).to receive(:http_code).and_return(200)
      allow_any_instance_of(SIADE::V2::Drivers::MarquesINPI).to receive(:http_code).and_return(200)

      allow_any_instance_of(SIADE::V2::Drivers::BrevetsINPI).to receive(:perform_request)
      allow_any_instance_of(SIADE::V2::Drivers::ModelesINPI).to receive(:perform_request)
      allow_any_instance_of(SIADE::V2::Drivers::MarquesINPI).to receive(:perform_request)
    end

    subject { described_class.new(valid_siren(:inpi)).retrieve }

    describe 'return 200' do
      its(:http_code) { is_expected.to eq(200) }
    end

    describe 'one driver fails' do
      before do
        allow_any_instance_of(SIADE::V2::Drivers::BrevetsINPI).to receive(:http_code).and_return(404)
      end

      its(:http_code)       { is_expected.to eq(206) }
      its(:count_brevets)   { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }
      its(:latests_brevets) { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }
    end

    describe 'all drivers fail' do
      before do
        allow_any_instance_of(SIADE::V2::Drivers::BrevetsINPI).to receive(:http_code).and_return(404)
        allow_any_instance_of(SIADE::V2::Drivers::ModelesINPI).to receive(:http_code).and_return(503)
        allow_any_instance_of(SIADE::V2::Drivers::MarquesINPI).to receive(:http_code).and_return(422)
      end

      its(:http_code) { is_expected.to eq(404) }

      its(:count_brevets)   { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }
      its(:latests_brevets) { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }

      its(:count_modeles)   { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }
      its(:latests_modeles) { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }

      its(:count_marques)   { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }
      its(:latests_marques) { is_expected.to eq(SIADE::V2::Drivers::GenericDriver.new.send(:placeholder)) }
    end
  end
end
