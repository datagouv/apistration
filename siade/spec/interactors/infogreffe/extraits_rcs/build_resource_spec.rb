RSpec.describe Infogreffe::ExtraitsRCS::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(params:, response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) do
    Infogreffe::MakeRequest.call(params:).response.body
  end

  let(:params) do
    {
      siren:
    }
  end

  describe '.call personne morale', vcr: { cassette_name: 'infogreffe/with_valid_siren_personne_morale' } do
    let(:siren) { valid_siren(:extrait_rcs) }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data }

      its(:siren) { is_expected.to eq('418166096') }
      its(:date_immatriculation) { is_expected.to eq('2000-01-15') }
      its(:date_extrait) { is_expected.to eq('30 MAI 2017') }
      its(:nom_commercial) { is_expected.to eq('EXEMPLE-TECHNOLOGIE') }

      its(:greffe) { is_expected.to be_an_instance_of(Hash) }

      describe 'greffe' do
        subject(:greffe) { instance.bundled_data.data.greffe }

        it { expect(greffe[:valeur]).to eq('PARIS') }
        it { expect(greffe[:code]).to eq('7501') }
      end

      its(:adresse_siege) { is_expected.to be_an_instance_of(Hash) }

      describe 'adresse_siege' do
        subject(:adresse_siege) { instance.bundled_data.data.adresse_siege }

        it { expect(adresse_siege[:nom_postal]).to eq('34 AVENUE DE L\'OPERA') }
        it { expect(adresse_siege[:numero]).to eq('') }
        it { expect(adresse_siege[:type]).to eq('') }
        it { expect(adresse_siege[:voie]).to eq('') }
        it { expect(adresse_siege[:ligne_1]).to eq('34 AVENUE DE L\'OPERA') }
        it { expect(adresse_siege[:ligne_2]).to eq('75002 PARIS (FRANCE) ') }
        it { expect(adresse_siege[:localite]).to eq('') }
        it { expect(adresse_siege[:code_postal]).to eq('75002') }
        it { expect(adresse_siege[:bureau_distributeur]).to eq('PARIS') }
        it { expect(adresse_siege[:pays]).to eq('FRANCE') }
      end

      its(:etablissement_principal) { is_expected.to be_an_instance_of(Hash) }

      describe 'etablissement principal' do
        subject(:etablissement_principal) { instance.bundled_data.data.etablissement_principal }

        it { expect(etablissement_principal[:activite]).to eq('GAGNER DES SOUS') }
        it { expect(etablissement_principal[:origine_fonds]).to eq('CREATION') }
        it { expect(etablissement_principal[:mode_exploitation]).to eq('EXPLOITATION DIRECTE') }
        it { expect(etablissement_principal[:code_ape]).to eq('6202A') }
      end

      its(:capital) { is_expected.to be_an_instance_of(Hash) }

      describe 'capital' do
        subject(:capital) { instance.bundled_data.data.capital }

        it { expect(capital[:montant]).to eq(234_567.8) }
        it { expect(capital[:devise]).to eq('') }
        it { expect(capital[:code_devise]).to eq('') }
      end

      its(:observations) { is_expected.to be_an_instance_of(Array) }

      describe 'resource.observations entry' do
        subject(:observation) { instance.bundled_data.data.observations[0] }

        it { expect(observation[:numero]).to eq('12197') }
        it { expect(observation[:libelle]).to eq('LA SOCIETE NE CONSERVE AUCUNE ACTIVITE A SON ANCIEN SIEGE') }
        it { expect(observation[:date]).to eq('2001-02-12') }
      end

      its(:mandataires_sociaux) { is_expected.to be_an_instance_of(Array) }

      describe 'resource.mandataires_sociaux entry pp' do
        subject(:mandataire_social) { instance.bundled_data.data.mandataires_sociaux[0] }

        it { expect(mandataire_social[:type]).to eq('personne_physique') }
        it { expect(mandataire_social[:nom]).to eq('DURANT') }
        it { expect(mandataire_social[:prenom]).to eq('ALEX') }
        it { expect(mandataire_social[:fonction]).to eq('PRESIDENT DU DIRECTOIRE') }
        it { expect(mandataire_social[:date_naissance]).to eq('1980-02') }
      end

      describe 'resource.mandataires_sociaux entry pm' do
        subject(:mandataire_social) { instance.bundled_data.data.mandataires_sociaux[9] }

        it { expect(mandataire_social[:type]).to eq('personne_morale') }
        it { expect(mandataire_social[:numero_identification]).to eq('123456789') }
        it { expect(mandataire_social[:fonction]).to eq('COMMISSAIRE AUX COMPTES TITULAIRE') }
        it { expect(mandataire_social[:raison_sociale]).to eq('MAZARS - SOCIETE ANONYME') }
      end
    end

    describe 'personne morale' do
      subject(:personne_morale) { instance.bundled_data.data.personne_morale }

      it { expect(personne_morale[:denomination]).to eq('EXEMPLE-TECHNOLOGIE') }
      it { expect(personne_morale[:date_fin_de_vie]).to eq('2099-01-15') }
      it { expect(personne_morale[:date_cloture_exercice_comptable]).to eq('12-31') }

      it { expect(personne_morale[:forme_juridique]).to be_an_instance_of(Hash) }

      describe 'forme_juridique' do
        subject(:forme_juridique) { instance.bundled_data.data.personne_morale[:forme_juridique] }

        it { expect(forme_juridique[:valeur]).to eq('SOCIETE ANONYME') }
        it { expect(forme_juridique[:code]).to eq('SAh') }
      end
    end

    describe 'personne_physique' do
      subject(:personne_physique) { instance.bundled_data.data.personne_physique }

      it { expect(personne_physique[:nom]).to be_empty }
      it { expect(personne_physique[:prenom]).to be_empty }

      it { expect(personne_physique[:adresse]).to be_an_instance_of(Hash) }

      describe 'adresse' do
        subject(:adresse) { instance.bundled_data.data.personne_physique[:adresse] }

        it { expect(adresse[:nom_postal]).to be_empty }
        it { expect(adresse[:numero]).to be_empty }
        it { expect(adresse[:type]).to be_empty }
        it { expect(adresse[:voie]).to be_empty }
        it { expect(adresse[:ligne_1]).to be_empty }
        it { expect(adresse[:ligne_2]).to be_empty }
        it { expect(adresse[:localite]).to be_empty }
        it { expect(adresse[:code_postal]).to be_empty }
        it { expect(adresse[:bureau_distributeur]).to be_empty }
        it { expect(adresse[:pays]).to be_empty }
      end

      it { expect(personne_physique[:nationalite]).to be_an_instance_of(Hash) }

      describe 'nationalite' do
        subject(:nationalite) { instance.bundled_data.data.personne_physique[:nationalite] }

        it { expect(nationalite[:valeur]).to be_empty }
        it { expect(nationalite[:code]).to be_empty }
      end

      it { expect(personne_physique[:naissance]).to be_an_instance_of(Hash) }

      describe 'naissance' do
        subject(:naissance) { instance.bundled_data.data.personne_physique[:naissance] }

        it { expect(naissance[:date]).to be_empty }
        it { expect(naissance[:lieu]).to be_empty }

        it { expect(naissance[:pays]).to be_an_instance_of(Hash) }

        describe 'pays' do
          subject(:naissance) { instance.bundled_data.data.personne_physique[:naissance][:pays] }

          it { expect(naissance[:valeur]).to be_empty }
          it { expect(naissance[:code]).to be_empty }
        end
      end
    end
  end

  describe '.call personne physique', vcr: { cassette_name: 'infogreffe/with_valid_siren_personne_physique' } do
    let(:siren) { valid_siren(:extrait_rcs_personne_physique) }

    it { is_expected.to be_a_success }

    describe 'resource' do
      describe 'personne morale' do
        subject(:personne_morale) { instance.bundled_data.data.personne_morale }

        it { expect(personne_morale[:denomination]).to be_empty }
        it { expect(personne_morale[:date_fin_de_vie]).to be_empty }
        it { expect(personne_morale[:date_cloture_exercice_comptable]).to be_empty }

        it { expect(personne_morale[:forme_juridique]).to be_an_instance_of(Hash) }

        describe 'forme_juridique' do
          subject(:forme_juridique) { instance.bundled_data.data.personne_morale[:forme_juridique] }

          it { expect(forme_juridique[:valeur]).to be_empty }
          it { expect(forme_juridique[:code]).to be_empty }
        end
      end

      describe 'personne_physique' do
        subject(:personne_physique) { instance.bundled_data.data.personne_physique }

        it { expect(personne_physique[:nom]).to eq('SPLOUSHY') }
        it { expect(personne_physique[:prenom]).to eq('FANCY MCFACE') }

        it { expect(personne_physique[:adresse]).to be_an_instance_of(Hash) }

        describe 'adresse' do
          subject(:adresse) { instance.bundled_data.data.personne_physique[:adresse] }

          it { expect(adresse[:nom_postal]).to eq('') }
          it { expect(adresse[:numero]).to eq('') }
          it { expect(adresse[:type]).to eq('') }
          it { expect(adresse[:voie]).to eq('UN ENDROIT ') }
          it { expect(adresse[:ligne_1]).to eq('') }
          it { expect(adresse[:ligne_2]).to eq('UN ENDROIT ') }
          it { expect(adresse[:localite]).to eq('') }
          it { expect(adresse[:code_postal]).to eq('40440') }
          it { expect(adresse[:bureau_distributeur]).to eq('UNBUREAU') }
          it { expect(adresse[:pays]).to eq('') }
        end

        it { expect(personne_physique[:nationalite]).to be_an_instance_of(Hash) }

        describe 'nationalite' do
          subject(:nationalite) { instance.bundled_data.data.personne_physique[:nationalite] }

          it { expect(nationalite[:valeur]).to eq('FRANCAISE') }
          it { expect(nationalite[:code]).to eq('FR') }
        end

        it { expect(personne_physique[:naissance]).to be_an_instance_of(Hash) }

        describe 'naissance' do
          subject(:naissance) { instance.bundled_data.data.personne_physique[:naissance] }

          it { expect(naissance[:date]).to eq('1971-02-26') }
          it { expect(naissance[:lieu]).to eq('UNEVILLE') }

          it { expect(naissance[:pays]).to be_an_instance_of(Hash) }

          describe 'pays' do
            subject(:naissance) { instance.bundled_data.data.personne_physique[:naissance][:pays] }

            it { expect(naissance[:valeur]).to eq('FRANCE') }
            it { expect(naissance[:code]).to eq('FR') }
          end
        end
      end
    end
  end
end
