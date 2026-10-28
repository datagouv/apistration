class APIEntreprise::AuthorizationRequestMailer < APIEntrepriseMailer
  include AuthorizationRequestMailersCommons

  authorization_request_emails(
    *%w[
      embarquement_demande_refusee
      update_embarquement_demande_refusee
      embarquement_modifications_demandees
      update_embarquement_modifications_demandees
      embarquement_valide_to_editeur
      embarquement_valide_to_demandeur_is_tech_is_metier
      embarquement_valide_to_demandeur_seulement
      embarquement_valide_to_metier_cc_demandeur_tech
      embarquement_valide_to_demandeur_is_metier_not_tech
      embarquement_valide_to_demandeur_is_tech_not_metier
      embarquement_valide_to_tech_cc_demandeur_metier
      update_embarquement_valide_to_demandeur
      demande_recue
      update_demande_recue
    ]
  )
end
