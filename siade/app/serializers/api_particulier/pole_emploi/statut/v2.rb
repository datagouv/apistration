class APIParticulier::PoleEmploi::Statut::V2 < APIParticulier::V2BaseSerializer
  attribute :identifiant, if: -> { scope?(:pole_emploi_identite) } do
    object.identifiant
  end

  attribute :civilite, if: -> { scope?(:pole_emploi_identite) } do
    binding
    object.identite[:civilite]
  end

  attribute :nom, if: -> { scope?(:pole_emploi_identite) } do
    object.identite[:nom_naissance]
  end

  attribute :nomUsage, if: -> { scope?(:pole_emploi_identite) } do
    object.identite[:nom_usage]
  end

  attribute :prenom, if: -> { scope?(:pole_emploi_identite) } do
    object.identite[:prenom]
  end

  attribute :sexe, if: -> { scope?(:pole_emploi_identite) } do
    object.identite[:sexe]
  end

  attribute :dateNaissance, if: -> { scope?(:pole_emploi_identite) } do
    object.identite[:date_naissance]
  end

  attribute :codeCertificationCNAV, if: -> { scope?(:pole_emploi_inscription) } do
    object.inscription[:code_certification_cnav]
  end

  attribute :codeCategorieInscription, if: -> { scope?(:pole_emploi_inscription) } do
    object.inscription[:categorie][:code]
  end

  attribute :libelleCategorieInscription, if: -> { scope?(:pole_emploi_inscription) } do
    object.inscription[:categorie][:libelle]
  end

  attribute :dateInscription, if: -> { scope?(:pole_emploi_inscription) } do
    object.inscription[:date_debut]
  end

  attribute :dateCessationInscription, if: -> { scope?(:pole_emploi_inscription) } do
    object.inscription[:date_fin]
  end

  attribute :adresse, if: -> { scope?(:pole_emploi_adresse) }

  attribute :email, if: -> { scope?(:pole_emploi_contact) } do
    object.contact[:email]
  end

  attribute :telephone, if: -> { scope?(:pole_emploi_contact) } do
    object.contact[:telephone]
  end

  attribute :telephone2, if: -> { scope?(:pole_emploi_contact) } do
    object.contact[:telephone2]
  end
end
