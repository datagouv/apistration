require 'rails_helper'

describe PROBTP::AttestationsCotisationsRetraite, :self_hosted_doc do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siret: siret,
      }
    end

    context 'when the attestation is found', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
      let(:siret) { eligible_siret(:probtp) }

      it { is_expected.to be_success }

      #FIXME this spec is not passing, but the following one does
      xit(:resource) do
        is_expected.to include(
          document_url: be_a_valid_self_hosted_pdf_url('attestation_cotisation_retraite_probtp'),
        )
      end

      it 'uploads the attestation on the self hosted storage' do
        document_url = subject.resource.document_url

        expect(document_url).to be_a_valid_self_hosted_pdf_url('attestation_cotisation_retraite_probtp')
      end
    end

    #FIXME
    context 'when the attestation is not found' do

    end

    #FIXME
    context 'when the siret is not eligible' do

    end
  end
end
