RSpec.describe INSEE::UniteLegale::BuildResource, type: :build_resource do
  subject { organizer }

  describe 'with an unite legale response' do
    let(:organizer) { described_class.call(response:) }
    let(:response) { instance_double(Net::HTTPOK, body:) }

    let(:body) do
      INSEE::UniteLegale::MakeRequest.call(params:, token: 'valid insee token').response.body
    end

    let(:params) do
      {
        siren:
      }
    end

    context 'with a partially diffusible personne physique' do
      let(:body) { open_payload_file('insee/partially_diffusible_unite_legale_personne_physique.json').read }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:siren) { is_expected.to eq('808861199') }
        its(:siret_siege_social) { is_expected.to eq('80886119900020') }
        its(:type) { is_expected.to eq(:personne_physique) }
        its(:diffusable_commercialement) { is_expected.to be(false) }
        its(:status_diffusion) { is_expected.to be(:partiellement_diffusible) }
      end
    end

    context 'with an active GE, which is a personne morale', vcr: { cassette_name: 'insee/siren/active_GE' } do
      let(:siren) { sirens_insee_v3[:active_GE] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:siret_siege_social) { is_expected.to eq("#{siren}01294") }

        its(:categorie_entreprise) { is_expected.to eq('GE') }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:diffusible) }

        its(:type) { is_expected.to eq(:personne_morale) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: 'SPORT-EXEMPLE',
            sigle: nil
          })
        end

        its(:personne_physique_attributs) do
          is_expected.to eq({
            pseudonyme: nil,
            prenom_usuel: nil,
            prenom_1: nil,
            prenom_2: nil,
            prenom_3: nil,
            prenom_4: nil,
            nom_usage: nil,
            nom_naissance: nil,
            sexe: nil
          })
        end

        its(:forme_juridique) do
          is_expected.to eq({
            code: '5599',
            libelle: 'SA à conseil d\'administration (s.a.i.)'
          })
        end

        its(:activite_principale) do
          is_expected.to eq({
            code: '46.49Y',
            libelle: "Commerce de gros d\u2019autres biens domestiques",
            nomenclature: 'NAF2025'
          })
        end

        its(:activite_principale_naf_rev2) do
          is_expected.to eq({
            code: '46.49Z',
            libelle: "Commerce de gros (commerce interentreprises) d'autres biens domestiques",
            nomenclature: 'NAFRev2'
          })
        end

        its(:tranche_effectif_salarie) do
          is_expected.to eq({
            de: 2000,
            a: 4999,
            code: '51',
            intitule: '2 000 à 4 999 salariés',
            date_reference: '2016'
          })
        end

        its(:economie_sociale_et_solidaire) { is_expected.to be_nil }

        its(:date_creation) { is_expected.to eq(Date.parse('1977-01-01').to_time.to_i) }

        its(:etat_administratif) { is_expected.to eq('A') }
        its(:date_cessation) { is_expected.to be_nil }

        its(:date_derniere_mise_a_jour) { is_expected.to eq(Date.parse('2018-02-13').to_time.to_i) }
      end
    end

    context 'with an active AE, which is a personne physique', vcr: { cassette_name: 'insee/siren/active_AE' } do
      let(:siren) { sirens_insee_v3[:active_AE] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:type) { is_expected.to eq(:personne_physique) }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:diffusible) }

        its(:personne_morale_attributs) do
          is_expected.to eq({
            raison_sociale: nil,
            sigle: nil
          })
        end

        its(:personne_physique_attributs) do
          is_expected.to eq({
            pseudonyme: nil,
            prenom_usuel: 'ODILE',
            prenom_1: 'ODILE',
            prenom_2: 'RENEE',
            prenom_3: 'JANINE',
            prenom_4: nil,
            nom_usage: 'BAROIN',
            nom_naissance: 'BIDAU',
            sexe: 'F'
          })
        end
      end
    end

    context 'with an active association' do
      let(:body) { open_payload_file('insee/association.json').read }
      let(:siren) { association_siren }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:rna) { is_expected.to eq('W912007752') }
      end
    end

    context 'when there is a date of 1900-01-01' do
      let(:body) do
        json = JSON.parse(read_payload_file('insee/association.json'))
        json['uniteLegale']['dateCreationUniteLegale'] = '1900-01-01'
        json.to_json
      end
      let(:siren) { association_siren }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:date_creation) { is_expected.to be_nil }
      end
    end

    context 'with a ceased company', vcr: { cassette_name: 'insee/siren/ceased' } do
      let(:siren) { sirens_insee_v3[:ceased] }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:etat_administratif) { is_expected.to eq('C') }
        its(:date_cessation) { is_expected.to eq(Date.parse('2011-09-05').to_time.to_i) }
      end
    end
  end

  describe 'with an unite legale payload from an etablissement response', vcr: { cassette_name: 'insee/siret/active_GE' } do
    let(:organizer) { described_class.call(response:, unite_legale:) }

    let(:response) { INSEE::Etablissement::MakeRequest.call(params:, token: 'valid insee token').response }
    let(:unite_legale) do
      JSON.parse(response.body)['etablissement']['uniteLegale']
    end

    let(:params) do
      {
        siret:
      }
    end
    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }
  end

  describe 'activite principale around the NAF 2025 switch announced by Insee for January 2027' do
    subject(:resource) { organizer.bundled_data.data }

    let(:organizer) { described_class.call(response:) }
    let(:response) { instance_double(Net::HTTPOK, body: payload.to_json) }
    let(:payload) do
      JSON.parse(open_payload_file('insee/partially_diffusible_unite_legale_personne_morale.json').read).tap do |payload_before_switch|
        payload_before_switch['uniteLegale']['activitePrincipaleNAF25UniteLegale'] = '84.11Y'
      end
    end
    let(:current_periode) { payload['uniteLegale']['periodesUniteLegale'].find { |periode| periode['dateFin'].nil? } }

    context 'when Insee still sends, before the switch, both the NAF rev. 2 code and the NAF 2025 one' do
      it 'exposes each code under its own nomenclature' do
        expect(resource.activite_principale[:code]).to eq('84.11Y')
        expect(resource.activite_principale_naf_rev2[:code]).to eq('84.11Z')
      end
    end

    context 'when Insee codes the unite legale in NAF 2025 in activitePrincipaleUniteLegale and drops activitePrincipaleNAF25UniteLegale' do
      before do
        payload['uniteLegale'].delete('activitePrincipaleNAF25UniteLegale')
        current_periode['activitePrincipaleUniteLegale'] = '84.11Y'
        current_periode['nomenclatureActivitePrincipaleUniteLegale'] = 'NAF25'
      end

      it 'keeps exposing the NAF 2025 activity' do
        expect(resource.activite_principale).to eq(
          code: '84.11Y',
          libelle: 'Activités d’administration publique générale',
          nomenclature: 'NAF2025'
        )
      end

      it 'rebuilds the NAF rev. 2 code from the Insee correspondence table when it has a single antecedent' do
        expect(resource.activite_principale_naf_rev2).to eq(
          code: '84.11Z',
          libelle: 'Administration publique générale',
          nomenclature: 'NAFRev2'
        )
      end
    end

    context 'when Insee sends a code missing from both NAF referentials under a nomenclature we do not know' do
      before do
        payload['uniteLegale'].delete('activitePrincipaleNAF25UniteLegale')
        current_periode['activitePrincipaleUniteLegale'] = '99.99X'
        current_periode['nomenclatureActivitePrincipaleUniteLegale'] = 'NAF2027'
        allow(MonitoringService.instance).to receive(:track_with_added_context)
      end

      it 'warns us, so a change of the Insee format does not go unnoticed' do
        resource

        expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
          'warning',
          a_string_including('outside the known nomenclatures'),
          { code: '99.99X', nomenclature: 'NAF2027' },
          fingerprint: ['insee_unexpected_activite_principale']
        ).at_least(:once)
      end
    end

    context 'when Insee flags as NAF25 a code missing from our NAF 2025 referential' do
      before do
        payload['uniteLegale'].delete('activitePrincipaleNAF25UniteLegale')
        current_periode['activitePrincipaleUniteLegale'] = '99.99Y'
        current_periode['nomenclatureActivitePrincipaleUniteLegale'] = 'NAF25'
      end

      it 'trusts the Insee nomenclature and exposes the code as NAF 2025, never as NAF rev. 2' do
        expect(resource.activite_principale[:code]).to eq('99.99Y')
        expect(resource.activite_principale_naf_rev2[:code]).to be_nil
      end
    end

    context 'when the NAF 2025 code has several NAF rev. 2 antecedents in the Insee correspondence table' do
      before do
        payload['uniteLegale'].delete('activitePrincipaleNAF25UniteLegale')
        current_periode['activitePrincipaleUniteLegale'] = '01.13Y'
        current_periode['nomenclatureActivitePrincipaleUniteLegale'] = 'NAF25'
      end

      it 'leaves the NAF rev. 2 code empty rather than guessing' do
        expect(resource.activite_principale_naf_rev2[:code]).to be_nil
      end
    end

    context 'when the unite legale keeps a NAF rev. 2 code after the switch, as ceased ones do' do
      before do
        payload['uniteLegale'].delete('activitePrincipaleNAF25UniteLegale')
        current_periode['etatAdministratifUniteLegale'] = 'C'
      end

      it 'exposes the NAF rev. 2 code and no NAF 2025 code' do
        expect(resource.activite_principale_naf_rev2[:code]).to eq('84.11Z')
        expect(resource.activite_principale[:code]).to be_nil
      end
    end
  end
end
