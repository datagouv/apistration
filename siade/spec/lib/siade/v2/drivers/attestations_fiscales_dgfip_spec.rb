RSpec.describe SIADE::V2::Drivers::AttestationsFiscalesDGFIP, :self_hosted_doc, type: :provider_driver do
  subject do
    described_class.new(
      {
        siren: siren,
        other_params: {
          cookie: cookie,
          user_id: user_id,
          informations: informations
        }
      }
    ).perform_request
  end

  let(:cookie) { AuthenticateDGFIPService.new.authenticate!.cookie }
  let(:user_id) { valid_dgfip_user_id }
  let(:informations) do
    SIADE::V2::Retrievers::AttestationsFiscalesDGFIP.new(
      {
        siren: siren,
        cookie: cookie,
        user_id: user_id
      }
    ).send(:retrieve_dgfip_informations)
  end

  context 'siren inconnu chez la DGFIP', vcr: { cassette_name: 'attestations_fiscales_dgfip_driver_with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    its(:http_code) { is_expected.to eq(404) } # DGFIP send 503 here
  end

  context 'siren inconnu chez la DGFIP', vcr: { cassette_name: 'attestations_fiscales_dgfip_driver_with_ceased_siren' } do
    let(:siren) { ceased_siren }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'siren found and valid pdf', vcr: { cassette_name: 'attestations_fiscales_dgfip_driver_with_valid_siren' } do
    let(:siren) { valid_siren(:dgfip) }

    its(:http_code) { is_expected.to eq(200) }
    its(:document_url) { is_expected.to be_a_valid_self_hosted_pdf_url('attestation_fiscale_dgfip') }
  end

  context 'siren found and invalid pdf', vcr: { cassette_name: 'attestations_fiscales_dgfip_driver_with_valid_siren' } do
    let(:siren) { valid_siren(:dgfip) }

    before do
      allow_any_instance_of(SIADE::SelfHostedDocument::FormatValidator)
        .to receive(:valid?).and_return(false)
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error("Le fichier n'est pas au format `pdf` attendu.") }
  end
end
