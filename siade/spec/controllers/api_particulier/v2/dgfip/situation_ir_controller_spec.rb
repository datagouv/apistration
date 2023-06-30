RSpec.describe APIParticulier::V2::DGFIP::SituationIRController do
  subject { get :show, params: { numeroFiscal: tax_number, referenceAvis: tax_notice_number, token: } }

  let(:all_dgfip_ir_scopes) { Rails.application.config_for(:authorizations)['api_particulier/v2/dgfip/situation_ir'] }
  let(:all_keys) do
    %w[
      declarant1
      declarant2
      foyerFiscal
      dateRecouvrement
      dateEtablissement
      nombreParts
      situationFamille
      nombrePersonnesCharge
      revenuBrutGlobal
      revenuImposable
      impotRevenuNetAvantCorrections
      montantImpot
      revenuFiscalReference
      anneeImpots
      anneeRevenus
      erreurCorrectif
      situationPartielle
    ]
  end

  let(:token) { TokenFactory.new(scopes).valid }

  let(:tax_number) { valid_tax_number }
  let(:tax_notice_number) { valid_tax_notice_number }

  describe 'with valid params' do
    before do
      affect_scopes_to_yes_jwt_token(scopes)
    end

    after(:all) do
      reset_yes_jwt_token_scopes!
    end

    context 'when API returns 200', vcr: { cassette_name: 'dgfip/situation_ir/valid' } do
      context 'when token has full access' do
        let(:scopes) { all_dgfip_ir_scopes }

        its(:status) { is_expected.to eq(200) }

        it 'returns all fields' do
          json = JSON.parse(subject.body)

          all_keys.each do |key|
            expect(json).to have_key(key), "#{key} is missing"
          end

          %w[declarant1 declarant2].each do |declarant_key|
            %w[nomNaissance prenoms dateNaissance].each do |key|
              expect(json[declarant_key]).to have_key(key), "#{declarant_key}->#{key} is missing"
            end
          end

          %w[adresse annee].each do |key|
            expect(json['foyerFiscal']).to have_key(key), "declarant1->#{key} is missing"
          end
        end
      end

      context 'when dgfip_declarant1_nom is missing' do
        let(:scopes) { all_dgfip_ir_scopes - %w[dgfip_declarant1_nom] }

        it 'does not return this field, which is in declarant1 payload' do
          json = JSON.parse(subject.body)

          %w[nomNaissance prenoms dateNaissance].each do |key|
            expect(json['declarant1']).to have_key(key), "declarant1->#{key} is missing"
          end

          expect(json['declarant1']).not_to have_key('nom')
        end
      end
    end
  end
end
