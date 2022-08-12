RSpec.describe APIParticulier::V2::DGFIP::SVAIRController, type: :controller do
  subject { get :show, params: { numeroFiscal: tax_number, referenceAvis: tax_notice_number, token: } }

  let(:all_scopes) { described_class.new.send(:scopes) }
  let(:all_keys) do
    %w[
      declarant1
      declarant2
      foyerFiscale
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

  describe 'with valid params' do
    let(:token) { TokenFactory.new(scopes).valid }

    let(:tax_number) { '1234567890ABC' }
    let(:tax_notice_number) { '1234567890ABC' }

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
          expect(json['foyerFiscale']).to have_key(key), "declarant1->#{key} is missing"
        end
      end
    end

    context 'when dgfip_declarant1_nom is missing' do
      let(:scopes) { all_scopes - %i[dgfip_declarant1_nom] }

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
