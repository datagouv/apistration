require 'rails_helper'

describe PROBTP::AttestationsCotisationsRetraite::ValidateResponse do
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

      it { is_expected.to be_success }
    end

    context 'when the attestation is not found' do
      #FIXME
    end

    context 'when there is an internal error from PROBTP (expected valid JSON error)' do
      #FIXME
    end

    context 'when there is an internal error from PROBTP (unexpected error body)' do
      #FIXME
    end
  end
end
