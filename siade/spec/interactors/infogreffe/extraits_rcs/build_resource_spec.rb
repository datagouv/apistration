RSpec.describe Infogreffe::ExtraitsRCS::BuildResource, type: :build_resource do
  let(:instance) { described_class.call(params:, response:) }

  describe '.call', vcr: { cassette_name: 'infogreffe/extraits_rcs/with_valid_siren' } do
    subject { instance }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      Infogreffe::MakeRequest.call(params:).response.body
    end

    let(:params) do
      {
        siren: valid_siren(:extrait_rcs)
      }
    end

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.resource }

      its(:siren) { is_expected.to eq('418166096') }
      its(:date_immatriculation) { is_expected.to eq('1998-03-27') }
      its(:date_extrait) { is_expected.to eq('30 MAI 2017') }
      its(:denomination) { is_expected.to eq('OCTO-TECHNOLOGYMAZARS - SOCIETE ANONYMEBCRH & ASSOCIES - SOCIETE A RESPONSABILITE LIMITEE') }
      its(:nom_commercial) { is_expected.to eq('OCTO-TECHNOLOGY') }
      its(:forme_juridique) { is_expected.to eq('SOCIETE ANONYME') }
      its(:code_forme_juridique) { is_expected.to eq('SAh') }
      its(:greffe) { is_expected.to eq('PARIS') }
      its(:code_greffe) { is_expected.to eq('7501') }
      its(:date_cloture_exercice_comptable) { is_expected.to eq('12-31') }
      its(:date_fin_de_vie) { is_expected.to eq('2097-03-26') }

      its(:adresse_siege) { is_expected.to be_an_instance_of(Hash) }

      describe 'adresse_siege' do
        subject(:adresse_siege) { instance.resource.adresse_siege }

        it { expect(adresse_siege[:nom_postal]).to eq('34 AVENUE DE L\'OPERA') }
        it { expect(adresse_siege[:numero]).to eq('') }
        it { expect(adresse_siege[:type]).to eq('') }
        it { expect(adresse_siege[:voie]).to eq('') }
        it { expect(adresse_siege[:ligne_1]).to eq('34 AVENUE DE L\'OPERA') }
        it { expect(adresse_siege[:ligne_2]).to eq('75002 PARIS (FRANCE) ') }
        it { expect(adresse_siege[:localite]).to be_nil }
        it { expect(adresse_siege[:code_postal]).to eq('75002') }
        it { expect(adresse_siege[:bureau_distributeur]).to eq('PARIS') }
        it { expect(adresse_siege[:pays]).to eq('FRANCE') }
      end

      its(:etablissement_principal) { is_expected.to be_an_instance_of(Hash) }

      describe 'etablissement principal' do
        subject(:etablissement_principal) { instance.resource.etablissement_principal }

        it { expect(etablissement_principal[:adresse]).to be_an_instance_of(Hash) }
        it { expect(etablissement_principal[:activite]).to eq('GAGNER DES SOUS') }
        it { expect(etablissement_principal[:origine_fonds]).to eq('CREATION') }
        it { expect(etablissement_principal[:mode_exploitation]).to eq('EXPLOITATION DIRECTE') }
        it { expect(etablissement_principal[:code_ape]).to eq('6202A') }
      end

      its(:capital) { is_expected.to be_an_instance_of(Hash) }

      describe 'capital' do
        subject(:capital) { instance.resource.capital }

        it { expect(capital[:montant]).to eq(509_525.3) }
        it { expect(capital[:devise]).to eq('') }
        it { expect(capital[:code_devise]).to eq('') }
      end

      its(:observations) { is_expected.to be_an_instance_of(Array) }

      describe 'resource.observations entry' do
        subject(:observation) { instance.resource.observations[0] }

        it { expect(observation[:numero]).to eq('12197') }
        it { expect(observation[:libelle]).to eq('LA SOCIETE NE CONSERVE AUCUNE ACTIVITE A SON ANCIEN SIEGE') }
        it { expect(observation[:date]).to eq('2000-02-23') }
      end

      its(:mandataires_sociaux) { is_expected.to be_an_instance_of(Array) }

      describe 'resource.mandataires_sociaux entry pp' do
        subject(:mandataire_social) { instance.resource.mandataires_sociaux[0] }

        it { expect(mandataire_social[:type]).to eq('personne_physique') }
        it { expect(mandataire_social[:nom]).to eq('HISQUIN') }
        it { expect(mandataire_social[:prenom]).to eq('FRANCOIS') }
        it { expect(mandataire_social[:fonction]).to eq('PRESIDENT DU DIRECTOIRE') }
        it { expect(mandataire_social[:date_naissance]).to eq('1965-01') }
      end

      describe 'resource.mandataires_sociaux entry pm' do
        subject(:mandataire_social) { instance.resource.mandataires_sociaux[9] }

        it { expect(mandataire_social[:type]).to eq('personne_morale') }
        it { expect(mandataire_social[:numero_identification]).to eq('784824153') }
        it { expect(mandataire_social[:fonction]).to eq('COMMISSAIRE AUX COMPTES TITULAIRE') }
        it { expect(mandataire_social[:raison_sociale]).to eq('MAZARS - SOCIETE ANONYME') }
      end
    end
  end
end
