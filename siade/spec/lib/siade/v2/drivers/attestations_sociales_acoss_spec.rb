RSpec.describe SIADE::V2::Drivers::AttestationsSocialesACOSS, :self_hosted_doc, type: :provider_driver do
  subject { described_class.new(siren: siren).perform_request }

  context 'siren unknown from URSSAF', vcr: { cassette_name: 'acoss/with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'siren found by URSSAF', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    context 'with a valid PDF content' do
      let(:siren) { valid_siren(:acoss) }

      its(:http_code) { is_expected.to eq(200) }
      its(:document_url) { is_expected.to be_a_valid_self_hosted_pdf_url('attestation_vigilance_acoss') }
    end

    context 'with a invalid PDF content' do
      let(:siren) { valid_siren(:acoss) }

      before do
        url = Siade.credentials[:acoss_domain]
        stub_request(:post, /#{url}/)
          .with(
            headers: { 'Content-Type' => 'application/json' })
          .to_return({ status: 200, body: "no pdf here" })
      end

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error('Erreur lors du décodage : invalide Base64 format') }
    end
  end

  describe 'forwarding params to ACOSS', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    subject { described_class.new(siren: siren, other_params: { user_id: user_id, recipient: recipient}) }

    let(:siren) { valid_siren :acoss }
    let(:user_id) { 'user id' }
    let(:recipient) { 'recipient' }

    it 'forwards the params to the request' do
      expect(SIADE::V2::Requests::AttestationsSocialesACOSS)
        .to receive(:new)
        .with(user_id: user_id, recipient: recipient, siren: siren, type_attestation: nil)
        .and_call_original
      subject.perform_request
    end
  end
end
