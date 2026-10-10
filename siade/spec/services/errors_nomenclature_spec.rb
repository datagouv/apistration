require 'rails_helper'

RSpec.describe ErrorsNomenclature, type: :service do
  subject(:nomenclature) { described_class.new(api).to_h }

  def codes_for(operation_id, status)
    nomenclature.dig('endpoints', operation_id, 'errors', status).pluck('code')
  end

  context 'with API Entreprise' do
    let(:api) { :entreprise }

    it 'names the API it describes' do
      expect(nomenclature['api']).to eq('entreprise')
    end

    it 'lists the provider prefixes and the generic subcodes' do
      expect(nomenclature['providers']).to include('04' => 'ACOSS', '00' => 'API Entreprise')
      expect(nomenclature['providers']).not_to have_key('26')
      expect(nomenclature['generic_subcodes']['001']).to include('title' => 'Service non disponible')
    end

    it 'documents the platform errors that need no provider' do
      expect(nomenclature.dig('platform_codes', '502').pluck('code')).to eq(['00501'])
      expect(nomenclature.dig('platform_codes', '400').pluck('code')).to eq(['00401'])
    end

    it 'documents once the errors the controller layer renders on every endpoint' do
      expect(nomenclature.dig('platform_codes', '422').pluck('code')).to include('00210')
      expect(nomenclature.dig('platform_codes', '404').pluck('code')).to include('00402')
      expect(nomenclature.dig('platform_codes', '403').pluck('code')).to include('00213')
      expect(codes_for('api_entreprise_v3_acoss_attestations_sociales', '422')).not_to include('00210')
    end

    it 'documents the DGFIP failures the Banque de France bilans relay from the dictionaries they fetch' do
      expect(codes_for('api_entreprise_v3_banque_de_france_bilans_entreprise', '502')).to include('03001')
      expect(codes_for('api_entreprise_v3_banque_de_france_bilans_entreprise', '503')).to include('03020')
    end

    it 'follows the organizer each version runs' do
      expect(codes_for('api_entreprise_v3_acoss_attestations_sociales', '502')).to include('04503')
      expect(codes_for('api_entreprise_v4_acoss_attestations_sociales', '502')).not_to include('04503')
    end

    it 'covers the errors of a document endpoint' do
      expect(codes_for('api_entreprise_v3_acoss_attestations_sociales', '502')).to include('04051', '04055', '00502')
    end

    it 'orders the statuses by what the caller has to do' do
      expect(nomenclature.dig('endpoints', 'api_entreprise_v3_acoss_attestations_sociales', 'errors').keys.first(3))
        .to eq(%w[422 404 502])
    end
  end

  context 'with API Particulier' do
    let(:api) { :particulier }

    it 'documents the MEN search validators the search params validator runs itself' do
      expect(codes_for('api_particulier_v5_men_scolarites_with_civility', '422')).to include('00410', '00412', '00413', '00414', '00416', '00417')
    end

    it 'gives the CNAV endpoints the prefix of the caisses they query' do
      expect(codes_for('api_particulier_v3_cnav_prime_activite_with_civility', '502')).to include('36000')
      expect(codes_for('api_particulier_v3_cnav_quotient_familial_with_civility', '502')).to include('35000')
    end

    it 'lists the 404 of every caisse behind a prestation, without the generic 404 the validator never renders' do
      expect(codes_for('api_particulier_v3_cnav_prime_activite_with_civility', '404'))
        .to eq(%w[10003 23003 35003 40003])
    end

    it 'keeps the generic 404 of a provider declaring none of its own' do
      expect(codes_for('api_particulier_v5_cnous_etudiant_boursier_with_civility', '404')).to include('26003')
    end

    it 'lists only the prefixes of API Particulier, 00 included' do
      expect(nomenclature['providers']).to include('00' => 'API Particulier', '26' => 'CNOUS', '51' => 'FranceConnect')
      expect(nomenclature['providers']).not_to have_key('04')
    end

    it 'keeps the meaning an endpoint declares over the baseline example of the same code' do
      not_found = nomenclature
        .dig('endpoints', 'api_particulier_v3_cnav_quotient_familial_with_civility', 'errors', '404')
        .find { |error| error['code'] == '35003' }

      expect(not_found['title']).to eq('Allocataire non référencé')
    end

    it 'documents the allocataire not eligible to the EAJE participation' do
      expect(codes_for('api_particulier_v3_cnav_participation_familiale_eaje_with_civility', '404')).to include('37003')
    end

    it 'adds the FranceConnect token errors to the FranceConnect variant only' do
      expect(codes_for('api_particulier_v3_cnav_prime_activite_with_france_connect', '401'))
        .to eq(%w[51501 51502 51504])
      expect(nomenclature.dig('endpoints', 'api_particulier_v3_cnav_prime_activite_with_civility', 'errors')).not_to have_key('401')
    end

    it 'documents the failures of the FranceConnect exchange on the FranceConnect variant' do
      expect(codes_for('api_particulier_v3_cnav_prime_activite_with_france_connect', '504')).to include('51002')
      expect(codes_for('api_particulier_v3_cnav_prime_activite_with_france_connect', '502')).to include('51999')
      expect(codes_for('api_particulier_v3_cnav_prime_activite_with_civility', '504')).not_to include('51002')
    end

    it 'gives FranceConnect no 404 since an unknown token is a 401' do
      expect(codes_for('api_particulier_v3_cnav_prime_activite_with_france_connect', '404')).not_to include('51003')
    end

    it 'names the field a validator rejects rather than the HTTP parameter' do
      expect(codes_for('api_particulier_v3_cnav_quotient_familial_with_civility', '422')).to include('00356')
      expect(codes_for('api_particulier_v3_cnav_quotient_familial_with_civility', '422')).not_to include('00307')
    end
  end
end
