RSpec.describe SIADE::V2::Requests::AttestationsFiscalesDGFIP, type: :provider_request do
  let(:valid_user_id) { valid_dgfip_user_id }

  before do
    allow_any_instance_of(SIADE::V2::Requests::INSEE::Etablissement).to receive(:insee_token).and_return('not a valid token')
    allow_any_instance_of(SIADE::V2::Requests::INSEE::Entreprise).to receive(:insee_token).and_return('not a valid token')
  end

  describe 'when is not valid' do
    subject do
      described_class.new(
        {
          siren: siren,
          siren_is: siren_is,
          siren_tva: siren_tva,
          cookie: cookie,
          informations: informations
        }
      ).perform
    end

    let(:valid_cookie) { valid_dgfip_cookie }
    let(:informations) do
      SIADE::V2::Retrievers::AttestationsFiscalesDGFIP.new(
        {
          siren: siren,
          siren_is: siren_is,
          siren_tva: siren_tva,
          user_id: user_id
        }
      ).send(:retrieve_dgfip_informations)
    end

    context 'should fail with invalid siren' do
      let(:siren) { invalid_siren }
      let(:siren_is) { nil }
      let(:siren_tva) { nil }
      let(:cookie) { valid_cookie }
      let(:user_id) { valid_user_id }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
    end

    context 'should fail with invalid siren_is' do
      let(:siren) { valid_siren(:dgfip) }
      let(:siren_is) { invalid_siren }
      let(:siren_tva) { nil }
      let(:cookie) { valid_cookie }
      let(:user_id) { valid_user_id }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error("Le siren_is n'est pas correctement formatté") }
    end

    context 'should fail with invalid siren_tva' do
      let(:siren) { valid_siren(:dgfip) }
      let(:siren_is) { nil }
      let(:siren_tva) { invalid_siren }
      let(:cookie) { valid_cookie }
      let(:user_id) { valid_user_id }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error("Le siren_tva n'est pas correctement formatté") }
    end

    context 'should fail with invalid user_id' do
      let(:siren) { valid_siren(:dgfip) }
      let(:siren_is) { nil }
      let(:siren_tva) { nil }
      let(:cookie) { valid_cookie }
      let(:user_id) { 'invalid@user_id' }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error("Le user_id n'est pas correctement formatté") }
    end

    context 'should fail with invalid informations' do
      let(:siren) { valid_siren(:dgfip) }
      let(:siren_is) { nil }
      let(:siren_tva) { nil }
      let(:cookie) { valid_cookie }
      let(:user_id) { valid_user_id }

      before do
        informations.groupe_is = 'wrong data'
      end

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error('Groupe IS doit valoir OUI ou NON') }
    end

    context 'should fail with invalid cookie' do
      let(:siren) { valid_siren(:dgfip) }
      let(:siren_is) { nil }
      let(:siren_tva) { nil }
      let(:cookie) { 'invalid_cookie' }
      let(:user_id) { valid_user_id }

      its(:http_code) { is_expected.to eq(502) }
      its(:errors) { is_expected.to have_error("L'authentification auprès du fournisseur de données 'DGFIP - Adélie' a échoué") }
    end
  end

  describe 'when is valid' do
    subject do
      described_class.new(
        {
          siren: siren,
          siren_is: siren_is,
          siren_tva: siren_tva,
          cookie: AuthenticateDGFIPService.new.authenticate!.cookie,
          informations: informations
        }
      ).perform
    end

    let(:informations) do
      SIADE::V2::Retrievers::AttestationsFiscalesDGFIP.new(
        {
          siren: siren,
          siren_is: siren_is,
          siren_tva: siren_tva,
          user_id: valid_user_id
        }
      ).send(:retrieve_dgfip_informations)
    end

    describe 'when non existent siren is sent', vcr: { cassette_name: 'attestations_fiscales_dgfip_request_with_non_existent_siren' } do
      let(:siren) { non_existent_siren }
      let(:siren_is) { nil }
      let(:siren_tva) { nil }

      its(:http_code) { is_expected.to eq(404) } # DGFIP send 503 here...
      its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu, n'est pas en règle de ses obligations fiscales ou ne comporte aucune information pour cet appel.") }
    end

    describe 'when closed siren is sent', vcr: { cassette_name: 'attestations_fiscales_dgfip_request_with_ceased_siren' } do
      let(:siren) { ceased_siren }
      let(:siren_is) { nil }
      let(:siren_tva) { nil }

      its(:http_code) { is_expected.to eq(404) } # DGFIP send 302 for this siren...
      its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu, n'est pas en règle de ses obligations fiscales ou ne comporte aucune information pour cet appel.") }
    end

    describe 'happy path', vcr: { cassette_name: 'attestations_fiscales_dgfip_request_valid_request' } do
      shared_examples 'valid_dgfip_response' do
        its(:http_code) { is_expected.to eq(200) }
        its(:errors) { is_expected.to be_empty }
      end

      context 'when only a siren is provided' do
        let(:siren) { valid_siren(:dgfip) }
        let(:siren_is) { nil }
        let(:siren_tva) { nil }

        it_behaves_like 'valid_dgfip_response'
      end

      context 'when siren IS is provided' do
        let(:siren) { valid_siren(:dgfip) }
        let(:siren_is) { danone_siren }
        let(:siren_tva) { nil }

        it_behaves_like 'valid_dgfip_response'
      end

      context 'when siren TVA is provided' do
        let(:siren) { valid_siren(:dgfip) }
        let(:siren_is) { nil }
        let(:siren_tva) { danone_siren }

        it_behaves_like 'valid_dgfip_response'
      end

      context 'when siren IS/TVA are provided' do
        let(:siren) { valid_siren(:dgfip) }
        let(:siren_is) { danone_siren }
        let(:siren_tva) { danone_siren }

        it_behaves_like 'valid_dgfip_response'
      end
    end
  end
end
