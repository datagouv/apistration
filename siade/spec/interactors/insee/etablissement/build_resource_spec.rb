RSpec.describe INSEE::Etablissement::BuildResource, type: :build_resource do
  subject { organizer }

  let(:organizer) { described_class.call(response:) }
  let(:response) { instance_double(Net::HTTPOK, body:) }

  let(:body) do
    INSEE::Etablissement::MakeRequest.call(params:, token: 'valid insee token').response.body
  end

  let(:params) do
    {
      siret:
    }
  end

  context 'with a personne physique' do
    let(:body) { open_payload_file('insee/partially_diffusible_etablissement_personne_physique.json').read }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:diffusable_commercialement) { is_expected.to be(false) }
      its(:status_diffusion) { is_expected.to be(:partiellement_diffusible) }
    end
  end

  context 'with an active GE, which is a personne morale', vcr: { cassette_name: 'insee/siret/active_GE' } do
    let(:siret) { sirets_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject(:resource) { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:siege_social) { is_expected.to be(false) }
      its(:etat_administratif) { is_expected.to eq('A') }
      its(:date_fermeture) { is_expected.to be_nil }
      its(:enseigne) { is_expected.to be_nil }
      its(:type) { is_expected.to eq(:personne_morale) }

      its(:activite_principale) do
        is_expected.to eq({
          code: '47.64Y',
          libelle: 'Commerce de détail de jeux et jouets',
          nomenclature: 'NAF2025'
        })
      end

      its(:activite_principale_naf_rev2) do
        is_expected.to eq({
          code: '47.64Z',
          libelle: "Commerce de détail d'articles de sport en magasin spécialisé",
          nomenclature: 'NAFRev2'
        })
      end

      its(:adresse) { is_expected.to be_present }

      # FIXME: d'après la doc ici NN n'est pas forcément non employeuse, à creuser
      its(:tranche_effectif_salarie) do
        is_expected.to eq({
          de: nil,
          a: nil,
          code: 'NN',
          intitule: 'Unités non employeuses',
          date_reference: nil
        })
      end

      its(:diffusable_commercialement) { is_expected.to be(true) }

      its(:date_creation) { is_expected.to eq(Date.parse('2004-05-26').to_time.to_i) }

      its(:date_derniere_mise_a_jour) { is_expected.to eq(Date.parse('2010-04-18').to_time.to_i) }
    end
  end

  context 'with a closed siret', vcr: { cassette_name: 'insee/siret/closed' } do
    let(:siret) { sirets_insee_v3[:closed] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:etat_administratif) { is_expected.to eq('F') }
      its(:date_fermeture) { is_expected.to eq(Date.parse('2011-09-05').to_time.to_i) }
    end
  end

  context 'with a closed siret without date of closing', vcr: { cassette_name: 'insee/siret/closed_without_date' } do
    let(:siret) { '78365263900015' }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:etat_administratif) { is_expected.to eq('F') }
      its(:date_fermeture) { is_expected.to be_nil }
    end
  end

  context 'with a siret which has an enseigne', vcr: { cassette_name: 'insee/siret/active_GE_ss' } do
    let(:siret) { sirets_insee_v3[:active_GE_ss] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      its(:enseigne) { is_expected.to eq('DECATHLON DIRECTION GENERALE FRANCE') }
    end
  end

  context 'with a siret which is a personne physique (auto entrepreneur)', vcr: { cassette_name: 'insee/siret/active_AE' } do
    let(:siret) { sirets_insee_v3[:active_AE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject(:resource) { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      it 'has a valid adresse->acheminement_postal->l2, which is nomUniteLegale concatenated with prenom1UniteLegale' do
        expect(resource.adresse.acheminement_postal[:l2]).to eq('BIDAU ODILE')
      end

      describe 'non-regression test: when there is no code cedex' do
        it 'has a valid adresse->acheminement_postal->l6, which includes postal code (and not commune code)' do
          expect(resource.adresse.acheminement_postal[:l6]).not_to include('71129')

          expect(resource.adresse.acheminement_postal[:l6]).to include('71540')
        end
      end
    end
  end

  context 'with a siege social payload, from a call to INSEE::SiegeUniteLegale::MakeRequest (which happens with redirect sirets)', vcr: { cassette_name: 'insee/siret/redirected' } do
    let(:siret) { '53222169400013' }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject(:resource) { organizer.bundled_data.data }

      it { is_expected.to be_a(Resource) }

      it 'has the redirected siret' do
        expect(subject.siret).to eq('77887067500015')
      end
    end
  end

  describe 'activite principale around the NAF 2025 switch announced by Insee for January 2027' do
    subject(:resource) { organizer.bundled_data.data }

    let(:body) { payload.to_json }
    let(:payload) do
      JSON.parse(open_payload_file('insee/partially_diffusible_etablissement_personne_morale.json').read).tap do |payload_before_switch|
        payload_before_switch['etablissement']['activitePrincipaleNAF25Etablissement'] = '42.99Y'
      end
    end
    let(:current_periode) { payload['etablissement']['periodesEtablissement'].find { |periode| periode['dateFin'].nil? } }

    context 'when Insee still sends, before the switch, both the NAF rev. 2 code and the NAF 2025 one' do
      it 'exposes each code under its own nomenclature' do
        expect(resource.activite_principale[:code]).to eq('42.99Y')
        expect(resource.activite_principale_naf_rev2[:code]).to eq('42.99Z')
      end
    end

    context 'when Insee codes the etablissement in NAF 2025 in activitePrincipaleEtablissement and drops activitePrincipaleNAF25Etablissement' do
      before do
        payload['etablissement'].delete('activitePrincipaleNAF25Etablissement')
        current_periode['activitePrincipaleEtablissement'] = '84.11Y'
        current_periode['nomenclatureActivitePrincipaleEtablissement'] = 'NAF25'
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
        payload['etablissement'].delete('activitePrincipaleNAF25Etablissement')
        current_periode['activitePrincipaleEtablissement'] = '99.99X'
        current_periode['nomenclatureActivitePrincipaleEtablissement'] = 'NAF2027'
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
        payload['etablissement'].delete('activitePrincipaleNAF25Etablissement')
        current_periode['activitePrincipaleEtablissement'] = '99.99Y'
        current_periode['nomenclatureActivitePrincipaleEtablissement'] = 'NAF25'
      end

      it 'trusts the Insee nomenclature and exposes the code as NAF 2025, never as NAF rev. 2' do
        expect(resource.activite_principale[:code]).to eq('99.99Y')
        expect(resource.activite_principale_naf_rev2[:code]).to be_nil
      end
    end

    context 'when the NAF 2025 code has several NAF rev. 2 antecedents in the Insee correspondence table' do
      before do
        payload['etablissement'].delete('activitePrincipaleNAF25Etablissement')
        current_periode['activitePrincipaleEtablissement'] = '01.13Y'
        current_periode['nomenclatureActivitePrincipaleEtablissement'] = 'NAF25'
      end

      it 'leaves the NAF rev. 2 code empty rather than guessing' do
        expect(resource.activite_principale_naf_rev2[:code]).to be_nil
      end
    end

    context 'when Insee sends a NAF 2025 code without the NAF25 nomenclature' do
      before do
        payload['etablissement'].delete('activitePrincipaleNAF25Etablissement')
        current_periode['activitePrincipaleEtablissement'] = '84.11Y'
        current_periode['nomenclatureActivitePrincipaleEtablissement'] = 'NAF2025'
      end

      it 'recognizes the code as NAF 2025 from the referential' do
        expect(resource.activite_principale[:code]).to eq('84.11Y')
        expect(resource.activite_principale_naf_rev2[:code]).to eq('84.11Z')
      end
    end

    context 'when the etablissement keeps a NAF rev. 2 code after the switch, as closed ones do' do
      before do
        payload['etablissement'].delete('activitePrincipaleNAF25Etablissement')
        current_periode['etatAdministratifEtablissement'] = 'F'
      end

      it 'exposes the NAF rev. 2 code and no NAF 2025 code' do
        expect(resource.activite_principale_naf_rev2[:code]).to eq('42.99Z')
        expect(resource.activite_principale[:code]).to be_nil
      end
    end
  end
end
