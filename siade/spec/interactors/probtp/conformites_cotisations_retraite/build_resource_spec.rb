RSpec.describe PROBTP::ConformitesCotisationsRetraite::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(params: params, response: response) }

    let(:response) { instance_double(Net::HTTPOK, code: code, body: body) }
    let(:params) do
      {
        siret: siret
      }
    end

    context 'when it is ok and conforme', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_eligible_siret' } do
      let(:siret) { eligible_siret(:probtp) }

      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: params)
          .response
          .body
      end

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_a(Resource) }

      it 'sets eligible as true' do
        expect(subject.resource.eligible).to eq(true)
      end
    end

    context 'when it is ok and not conforme', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_non_eligible_siret' } do
      let(:siret) { non_eligible_siret(:probtp) }

      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: non_eligible_siret(:probtp) })
          .response
          .body
      end

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_a(Resource) }

      it 'sets eligible as false' do
        expect(subject.resource.eligible).to eq(false)
      end
    end
  end
end
