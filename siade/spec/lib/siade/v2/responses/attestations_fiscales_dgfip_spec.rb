RSpec.describe SIADE::V2::Responses::AttestationsFiscalesDGFIP, type: :provider_response do
  subject do
    SIADE::V2::Requests::AttestationsFiscalesDGFIP.new({
      siren: siren,
      cookie: cookie,
      informations: informations
    }).perform.response
  end

  let(:user_id) { valid_dgfip_user_id }
  let(:cookie) { AuthenticateDGFIPService.new.authenticate!.cookie }
  let(:informations) do
    SIADE::V2::Retrievers::AttestationsFiscalesDGFIP.new(
      {
        siren: siren,
        cookie: cookie,
        user_id: user_id
      }
    ).send(:retrieve_dgfip_informations)
  end

  context 'when siren is found', vcr: { cassette_name: 'attestations_fiscales_dgfip_response_with_valid_siren' } do
    let(:siren) { valid_siren(:dgfip) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors)    { is_expected.to be_empty }
  end

  context 'when siren is not found', vcr: { cassette_name: 'attestations_fiscales_dgfip_response_with_ceased_siren' } do
    let(:siren) { ceased_siren }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors)    { is_expected.not_to be_empty }
  end

  context 'when siren is not found but raise 503', vcr: { cassette_name: 'attestations_fiscales_dgfip_response_with_non_existent_siren' } do
    let(:siren) { non_existent_siren }

    its(:http_code) { is_expected.to eq(404) } # DGFIP send 503 here
    its(:errors)    { is_expected.not_to be_empty }
    its(:errors)    { is_expected.to have_error('Le siret ou siren indiqué n\'existe pas, n\'est pas connu, n\'est pas en règle de ses obligations fiscales ou ne comporte aucune information pour cet appel.') }
  end

  describe 'non-regression test: when DGFIP renders a 502 error' do
    subject { SIADE::V2::Responses::AttestationsFiscalesDGFIP.new(bad_gateway_error) }

    let(:bad_gateway_error) do
      gateway_error = Struct.new(:code, :body)
      gateway_error.new(502, '')
    end

    its(:http_code) { is_expected.to eq(502) }
  end
end
