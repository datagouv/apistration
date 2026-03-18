RSpec.describe SIADE::V2::Drivers::AttestationsAGEFIPH, type: :provider_driver do
  describe '#perform_request' do
    subject { described_class.new(siret: siret).perform_request }

    let(:agefiph_microservice_get_url) { "http://127.0.0.1/agefiph/sirets/#{siret}" }
    let(:siret) { valid_siret(:agefiph) }

    let(:stubbed_request) do
      stub_request(:get, agefiph_microservice_get_url).to_return(
        {
          status: agefiph_microservice_get_status,
          body:   agefiph_microservice_get_body,
        }
      )
    end

    before do
      stubbed_request
    end

    context 'when siret exists through agefiph microservice' do
      let(:agefiph_microservice_get_status) { 200 }
      let(:agefiph_microservice_get_body) do
        {
          derniere_annee_de_conformite_connue: derniere_annee_de_conformite_connue,
          dump_date:                           dump_date_timestamp,
        }.to_json
      end
      let(:derniere_annee_de_conformite_connue) { '2016' }
      let(:dump_date_timestamp) { Time.now.to_i }

      it 'calls agefiph microservice with valid path and params' do
        subject

        expect(stubbed_request).to have_been_requested
      end

      it 'returns last annee conformite connue' do
        expect(subject.derniere_annee_de_conformite_connue).to eq(derniere_annee_de_conformite_connue)
      end

      it 'returns last dump date' do
        expect(subject.dump_date).to eq(dump_date_timestamp)
      end

      its(:success?)  { is_expected.to eq(true) }
      its(:http_code) { is_expected.to eq(200)  }
    end

    context 'when siret does not exist through agefiph microservice' do
      let(:agefiph_microservice_get_status) { 404 }
      let(:agefiph_microservice_get_body) { {}.to_json }

      its(:success?)  { is_expected.to eq(false) }
      its(:http_code) { is_expected.to eq(404)  }
    end

    context "when agefiph microservice returns a non-valid json" do
      let(:agefiph_microservice_get_status) { 200 }
      let(:agefiph_microservice_get_body) { 'PANIC' }

      its(:success?)  { is_expected.to eq(false) }
      its(:http_code) { is_expected.to eq(502)  }
    end
  end
end
