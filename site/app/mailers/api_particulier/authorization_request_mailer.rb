class APIParticulier::AuthorizationRequestMailer < APIParticulierMailer
  include AuthorizationRequestMailersCommons

  authorization_request_emails(
    *%w[
      demande_recue
      update_demande_recue

      embarquement_demande_refusee
      embarquement_modifications_demandees
      update_embarquement_demande_refusee
      update_embarquement_modifications_demandees

      embarquement_valide_to_demandeur_is_tech
      embarquement_valide_to_demandeur_seulement
      embarquement_valide_to_tech_cc_demandeur
      update_embarquement_valide_to_demandeur
    ]
  )
end
