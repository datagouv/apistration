# TODO add cassettes vcr
RSpec.describe SIADE::V2::Responses::CotisationsMSA, type: :provider_response do
  before do
    stub_request(:get, "https://msa_conformites_cotisations_url.gouv.fr/00701042400039")
      .to_return(status: 200, body: '{ "TopRMPResponse" : { "identifiantDebiteur" : "00701042400039", "topRegMarchePublic" : "S" }}')
  end

  subject { described_class.new(raw_response) }

  context 'when etablissement is not found' do
    let(:raw_response) { SIADE::V2::Requests::CotisationsMSA.new("00701042400039").perform }
    its(:http_code) { should eq(404) }
  end
end
