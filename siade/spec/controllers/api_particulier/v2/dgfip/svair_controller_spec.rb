RSpec.describe APIParticulier::V2::DGFIP::SVAIRController do
  subject { get :show, params: { numeroFiscal: tax_number, referenceAvis: tax_notice_number, token: } }

  let(:all_scopes) { Rails.application.config_for(:authorizations)['api_particulier/v2/dgfip/svair'] }
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

  let(:tax_number) { '1234567890ABC' }
  let(:tax_notice_number) { '1234567890ABC' }

  describe 'with valid params' do
    context 'when svair works' do
      before do
        mock_valid_dgfip_svair
      end

      context 'when token has full access' do
        let(:scopes) { all_scopes }

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
        let(:scopes) { all_scopes - %w[dgfip_declarant1_nom] }

        it 'does not return this field, which is in declarant1 payload' do
          json = JSON.parse(subject.body)

          %w[nomNaissance prenoms dateNaissance].each do |key|
            expect(json['declarant1']).to have_key(key), "declarant1->#{key} is missing"
          end

          expect(json['declarant1']).not_to have_key('nom')
        end
      end
    end

    context 'when it is not found' do
      let(:scopes) { all_scopes }

      before do
        mock_not_found_dgfip_svair
      end

      its(:status) { is_expected.to eq(404) }
    end

    context 'when svair is currently banned' do
      let(:scopes) { all_scopes }

      before do
        mock_access_denied_dgfip_svair
      end

      its(:status) { is_expected.to eq(509) }
    end
  end
end
