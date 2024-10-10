class APIParticulier::CNAV::QuotientFamilialV2::V2 < APIParticulier::V2BaseSerializer
  attribute :quotientFamilial, if: -> { scope?(:cnaf_quotient_familial) } do
    object.quotient_familial[:valeur]
  end

  attribute :mois, if: -> { scope?(:cnaf_quotient_familial) } do
    object.quotient_familial[:mois]
  end

  attribute :annee, if: -> { scope?(:cnaf_quotient_familial) } do
    object.quotient_familial[:annee]
  end

  attribute :allocataires, if: -> { scope?(:cnaf_allocataires) } do
    object.allocataires.map do |allocataire|
      {
        nomNaissance: allocataire[:nom_naissance],
        nomUsuel: allocataire[:nom_usage],
        prenoms: allocataire[:prenoms],
        anneDateDeNaissance: allocataire[:annee_date_de_naissance],
        moisDateDeNaissance: allocataire[:mois_date_de_naissance],
        jourDateDeNaissance: allocataire[:jour_date_de_naissance],
        sexe: allocataire[:sexe]
      }
    end
  end

  attribute :enfants, if: -> { scope?(:cnaf_enfants) } do
    object.enfants.map do |enfant|
      {
        nomNaissance: enfant[:nom_naissance],
        nomUsuel: enfant[:nom_usage],
        prenoms: enfant[:prenoms],
        anneDateDeNaissance: enfant[:annee_date_de_naissance],
        moisDateDeNaissance: enfant[:mois_date_de_naissance],
        jourDateDeNaissance: enfant[:jour_date_de_naissance],
        sexe: enfant[:sexe]
      }
    end
  end

  attribute :adresse, if: -> { scope?(:cnaf_adresse) } do
    {
      identite: object.adresse[:destinataire],
      complementInformation: object.adresse[:complement_information],
      complementInformationGeographique: object.adresse[:complement_information_geographique],
      numeroLibelleVoie: object.adresse[:numero_libelle_voie],
      lieuDit: object.adresse[:lieu_dit],
      codePostalVille: object.adresse[:code_postal_ville],
      pays: object.adresse[:pays]
    }
  end
end
