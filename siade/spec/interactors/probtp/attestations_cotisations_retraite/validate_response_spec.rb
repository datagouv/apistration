require 'rails_helper'

RSpec.describe PROBTP::AttestationsCotisationsRetraite::ValidateResponse do
  describe '.call' do
    subject { described_class.call(response: response) }

    let(:response) { instance_double(Net::HTTPOK, code: code, body: body) }

    context 'when the attestation is found', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
      let(:code) { 200 }
      let(:body) do
        PROBTP::AttestationsCotisationsRetraite::MakeRequest
          .call(params: { siret: eligible_siret(:probtp) })
          .response
          .body
      end

      it { is_expected.to be_a_success }
    end

    context 'when the attestation is not found', vcr: { cassette_name: 'probtp/attestation/with_not_found_siret' } do
      let(:code) { 200 }
      let(:body) do
        PROBTP::AttestationsCotisationsRetraite::MakeRequest
          .call(params: { siret: not_found_siret(:probtp) })
          .response
          .body
      end

      it { is_expected.to be_a_failure }
    end

    context 'when there is an internal error from PROBTP (expected valid JSON error)' do
      let(:code) { 200 }
      let(:body) { "{\"entete\":{\"code\":\"4\",\"message\":\"Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement\"}}" }

      it { is_expected.to be_a_failure }
    end

    context 'when there is an internal error from PROBTP (unexpected error body)' do
      let(:code) { 200 }
      let(:body) { "<H1>SRVE0255E: A WebGroup/Virtual Host to handle /ws_ext/rest/certauth/mpsservices/getAttestationCotisation has not been defined.</H1><BR>H3><SRVE0255E: A WebGroup/Virtual Host to handle partenaires.webservices.probtp.com:443 has not been defined./H3><BR>" }

      it { is_expected.to be_a_failure }
    end
  end
end
