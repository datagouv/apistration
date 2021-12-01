RSpec.describe SIADE::V2::Responses::LiassesFiscalesDGFIP, type: :provider_response do
  subject do
    SIADE::V2::Requests::LiassesFiscalesDGFIP.new(
      {
        siren: siren,
        annee: 2017,
        cookie: cookie,
        user_id: valid_dgfip_user_id,
        request_name: request_name
      }
    ).perform.response
  end

  let(:cookie) { AuthenticateDGFIPService.new.authenticate!.cookie }

  context 'with dictionary', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:request_name) { :dictionary }
    let(:siren) { valid_siren(:liasse_fiscale) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors)    { is_expected.to be_empty }
  end

  context 'when siren is found', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    let(:request_name) { :declaration }
    let(:siren) { valid_siren(:liasse_fiscale) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors)    { is_expected.to be_empty }
  end

  context 'when siren is not found', vcr: { cassette_name: 'liasses_fiscales_dgfip_with_ceased_siren' } do
    let(:request_name) { :declaration }
    let(:siren) { ceased_siren }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors)    { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
  end

  context 'when siren is not found but raise 503', vcr: { cassette_name: 'dgfip/liasses_fiscales/with_non_existent_siren' } do
    let(:request_name) { :declaration }
    let(:siren) { non_existent_siren }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors)    { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
  end

  context 'with dictionary and without siren', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
    subject do
      SIADE::V2::Requests::LiassesFiscalesDGFIP.new(
        {
          annee: 2017,
          cookie: cookie,
          user_id: valid_dgfip_user_id,
          request_name: request_name
        }
      ).perform.response
    end

    let(:request_name) { :dictionary }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors)    { is_expected.to be_empty }
  end
end
