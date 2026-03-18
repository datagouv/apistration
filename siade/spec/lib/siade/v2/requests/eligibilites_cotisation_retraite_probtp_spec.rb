RSpec.describe SIADE::V2::Requests::EligibilitesCotisationRetraitePROBTP, type: :provider_request do
  subject { described_class.new(siret).perform }

  context 'bad formated siret' do
    let(:siret) { invalid_siret }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors)    { is_expected.to have_error(invalid_siret_error_message) }
  end

  context 'well formated siret'  do
    context 'with non eligible siret', vcr: { cassette_name: 'probtp/eligibilite/with_non_eligible_siret' } do
      let(:siret) { non_eligible_siret(:probtp) }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }

      it 'should have code 0 and message 01' do
        json = JSON.parse(subject.body, symbolize_names: true)
        expect(json[:entete][:code]).to include('0')
        expect(json[:corps]).to include("01 Compte non éligible pour attestation de cotisation")
      end
    end

    context 'with eligible siret', vcr: { cassette_name: 'probtp/eligibilite/with_eligible_siret' } do
      let(:siret) { eligible_siret(:probtp) }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }

      it 'should have code O and message 00' do
        json = JSON.parse(subject.body, symbolize_names: true)
        expect(json).to include(
          entete: { code: '0' },
          corps:  "00 Compte éligible pour attestation de cotisation"
        )
      end
    end
  end
end
