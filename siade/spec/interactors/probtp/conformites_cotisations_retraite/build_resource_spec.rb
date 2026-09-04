RSpec.describe PROBTP::ConformitesCotisationsRetraite::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(params:, response:) }

    let(:response) { instance_double(Net::HTTPOK, code:, body:) }
    let(:params) do
      {
        siret:
      }
    end

    let(:resource) { subject.bundled_data.data }

    context 'when it is ok and conforme' do
      let(:siret) { eligible_siret(:probtp) }

      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params:)
          .response
          .body
      end

      before { stub_probtp_conformite_eligible }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        expect(resource).to be_a(Resource)
      end

      it 'sets eligible as true' do
        expect(resource.eligible).to be(true)
      end
    end

    context 'when it is ok and not conforme' do
      let(:siret) { non_eligible_siret(:probtp) }

      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: non_eligible_siret(:probtp) })
          .response
          .body
      end

      before { stub_probtp_conformite_non_eligible }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        expect(resource).to be_a(Resource)
      end

      it 'sets eligible as false' do
        expect(resource.eligible).to be(false)
      end
    end
  end
end
