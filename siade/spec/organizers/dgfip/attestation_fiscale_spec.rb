RSpec.describe DGFIP::AttestationFiscale, :self_hosted_doc, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:,
      user_id:
    }
  end

  let(:user_id) { yes_jwt_user.id }
  let(:siren) { valid_siren }

  context 'with valid attributes' do
    context 'when DGFIP works' do
      before do
        mock_dgfip_authenticate
        mock_valid_dgfip_attestation_fiscale(siren, valid_dgfip_user_id)
      end

      it { is_expected.to be_a_success }

      it 'uploads the attestation on the self hosted storage' do
        document_url = subject.resource.document_url

        expect(document_url).to be_a_valid_self_hosted_pdf_url('attestation_fiscale_dgfip')
      end
    end
  end

  context 'with invalid attributes' do
    let(:siren) { 'invalid' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
