RSpec.describe INSEE::EtablissementDiffusable::FilterResource, type: :filter_resource do
  subject { organizer }

  describe 'with an etablissement response' do
    let(:organizer) { described_class.call(builded_resources) }

    let(:builded_resources) { INSEE::EtablissementDiffusable::BuildUnfilteredResource.call(response:) }
    let(:response) { instance_double(Net::HTTPOK, body:) }

    context 'with a personne physique' do
      let(:body) { open_payload_file('insee/partially_diffusible_etablissement_personne_physique.json').read }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:enseigne) { is_expected.to eq('[ND]') }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:partiellement_diffusible) }

        its(:adresse) do
          is_expected.to be_a(Resource)
        end

        it {
          expect(subject.adresse.siret).to eq('80886119900020')

          expect(subject.adresse.complement_adresse).to eq('[ND]')
          expect(subject.adresse.numero_voie).to eq('[ND]')
          expect(subject.adresse.indice_repetition_voie).to eq('[ND]')
          expect(subject.adresse.type_voie).to eq('[ND]')
          expect(subject.adresse.libelle_voie).to eq('[ND]')
          expect(subject.adresse.code_postal).to eq('[ND]')
          expect(subject.adresse.distribution_speciale).to eq('[ND]')
          expect(subject.adresse.code_cedex).to eq('[ND]')
          expect(subject.adresse.libelle_cedex).to eq('[ND]')

          expect(subject.adresse.acheminement_postal[:l1]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l2]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l3]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l4]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l5]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l6]).to eq('[ND]')
        }

        its(:unite_legale) do
          is_expected.to be_a(Resource)
        end

        it {
          expect(subject.unite_legale.siren).to eq('808861199')
          expect(subject.unite_legale.type).to eq(:personne_physique)

          expect(subject.unite_legale.personne_morale_attributs[:raison_sociale]).to be_nil
          expect(subject.unite_legale.personne_morale_attributs[:sigle]).to be_nil
          expect(subject.unite_legale.personne_physique_attributs[:sexe]).to eq('[ND]')
        }

        its(:siege_social) { is_expected.to be(true) }
        its(:etat_administratif) { is_expected.to eq('A') }
        its(:date_fermeture) { is_expected.to be_nil }
      end
    end

    context 'with a personne morale' do
      let(:body) { open_payload_file('insee/partially_diffusible_etablissement_personne_morale.json').read }

      it { is_expected.to be_a_success }

      describe 'resource' do
        subject { organizer.bundled_data.data }

        it { is_expected.to be_a(Resource) }

        its(:enseigne) { is_expected.to eq('PAE -HM- LA FONTAINE') }
        its(:diffusable_commercialement) { is_expected.to be(true) }
        its(:status_diffusion) { is_expected.to be(:partiellement_diffusible) }

        its(:adresse) { is_expected.to be_a(Resource) }

        it {
          expect(subject.adresse.siret).to eq('24340081900120')

          expect(subject.adresse.complement_adresse).to eq('[ND]')
          expect(subject.adresse.numero_voie).to eq('[ND]')
          expect(subject.adresse.indice_repetition_voie).to eq('[ND]')
          expect(subject.adresse.type_voie).to eq('[ND]')
          expect(subject.adresse.libelle_voie).to eq('[ND]')
          expect(subject.adresse.code_postal).to eq('[ND]')
          expect(subject.adresse.distribution_speciale).to eq('[ND]')
          expect(subject.adresse.code_cedex).to eq('[ND]')
          expect(subject.adresse.libelle_cedex).to eq('[ND]')

          expect(subject.adresse.acheminement_postal[:l1]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l2]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l3]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l4]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l5]).to eq('[ND]')
          expect(subject.adresse.acheminement_postal[:l6]).to eq('[ND]')
        }

        its(:unite_legale) do
          is_expected.to be_a(Resource)
        end

        it {
          expect(subject.unite_legale.siren).to eq('243400819')
          expect(subject.unite_legale.type).to eq(:personne_morale)

          expect(subject.unite_legale.personne_morale_attributs[:raison_sociale]).to eq('COMMUNAUTE D AGGLOMERATION HERAULT MEDITERRANEE')
          expect(subject.unite_legale.personne_morale_attributs[:sigle]).to eq('[ND]')
          expect(subject.unite_legale.personne_physique_attributs[:sexe]).to be_nil
        }
      end
    end
  end
end
