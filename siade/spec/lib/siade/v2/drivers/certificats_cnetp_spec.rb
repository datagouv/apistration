RSpec.describe SIADE::V2::Drivers::CertificatsCNETP, :self_hosted_doc, type: :provider_driver do
  subject { described_class.new(siren: siren).perform_request }

  context 'siren inconnu chez CNETP', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/not_found_siren' } do
    let(:siren) { non_existent_siren }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'siren eligible au certificat CNETP', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/valid_siren' } do
    context 'with a valid PDF content' do
      let(:siren) { valid_siren(:cnetp) }

      its(:http_code) { is_expected.to eq(200) }
      its(:document_url) { is_expected.to be_a_valid_self_hosted_pdf_url('certificat_cnetp') }
    end

    context 'with a invalid PDF content' do
      let(:siren) { valid_siren(:cnetp) }

      before do
        url = 'https://cnetp_domain.gouv.fr/webservice/doc/attestations/entreprises'
        stub_request(:get, /#{url}/)
          .to_return({ status: 200, body: 'no pdf here' })
      end

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error(bad_pdf_error_message) }
    end
  end
end
