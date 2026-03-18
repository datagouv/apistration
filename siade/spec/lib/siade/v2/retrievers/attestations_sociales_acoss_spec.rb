RSpec.describe SIADE::V2::Retrievers::AttestationsSocialesACOSS do
  subject { described_class.new(siren: valid_siren) }

  let(:driver) { SIADE::V2::Drivers::AttestationsSocialesACOSS }

  it { is_expected.to be_delegated_to(driver, :http_code) }
  it { is_expected.to be_delegated_to(driver, :document_url ) }

  describe 'forwarding the params to the driver' do
    subject { described_class.new siren: valid_siren, user_id: user_id, recipient: recipient }

    let(:user_id) { 'user id' }
    let(:recipient) { 'recipient' }

    it 'forwards user_id and recipient' do
      expect(SIADE::V2::Drivers::AttestationsSocialesACOSS)
        .to receive(:new)
        .with(siren: valid_siren,
          other_params: {
            user_id: user_id,
            recipient: recipient,
            type_attestation: nil
          }
       )
      subject.driver_sociale
    end
  end
end
