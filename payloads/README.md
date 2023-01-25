# Payloads

Les chemins sans lien ne possèdent pas de payload: l'environnement de test
génère une payload par défaut basée sur la spécification OpenAPI associée.

## API Particulier

* [Service de vérification de l'avis d'impôt sur le revenu](api_particulier_v2_dgfip_svair) (`/v2/avis-imposition`)
* Informations concernant la famille (`/v2/composition-familiale`)
* Recherche de la situation Pôle Emploi d'un particulier (`/v2/situations-pole-emploi`)
* Recherche du statut étudiant d'un particulier (`/v2/etudiants`)
* [Recherche du statut étudiant boursier d'un particulier](api_particulier_v2_cnous_student_scholarship) (`/v2/etudiants-boursiers`)

## API Entreprise v3+

* Attestation de vigilance (`/v3/urssaf/unites_legales/{siren}/attestation_vigilance`)
* Certification RGE (`/v3/ademe/etablissements/{siret}/certification_rge`)
* 3 derniers bilans annuels (`/v3/banque_de_france/unites_legales/{siren}/bilans`)
* Attestation de cotisations congés payés & chômage-intempéries (`/v3/cnetp/unites_legales/{siren}/attestation_cotisations_conges_payes_chomage_intemperies`)
* Immatriculation EORI (`/v3/douanes/etablissements/{siret_or_eori}/immatriculations_eori`)
* Attestation fiscale (`/v3/dgfip/unites_legales/{siren}/attestation_fiscale`)
* Chiffre d'affaires (`/v3/dgfip/etablissements/{siret}/chiffres_affaires`)
* Liasses fiscales (`/v3/dgfip/unites_legales/{siren}/liasses_fiscales/{year}`)
* N°TVA intracommunautaire français (`/v3/european_commission/unites_legales/{siren}/numero_tva`)
* Conventions collectives (`/v3/fabrique_numerique_ministeres_sociaux/etablissements/{siret}/conventions_collectives`)
* Carte professionnelle travaux publics (`/v3/fntp/unites_legales/{siren}/carte_professionnelle_travaux_publics`)
* Extrait RCS (`/v3/infogreffe/rcs/unites_legales/{siren}/extrait_kbis`)
* Mandataires sociaux (`/v3/infogreffe/rcs/unites_legales/{siren}/mandataires_sociaux`)
* Actes (`/v3/inpi/unites_legales/{siren}/actes`)
* Brevets déposés (`/v3/inpi/unites_legales/{siren}/brevets`)
* Marques déposées (`/v3/inpi/unites_legales/{siren}/marques`)
* Modèles déposés (`/v3/inpi/unites_legales/{siren}/modeles`)
* Adresse établissement (`/v3/insee/sirene/etablissements/{siret}/adresse`)
* Adresse établissement diffusible (`/v3/insee/sirene/etablissements/diffusibles/{siret}/adresse`)
* Données établissement (`/v3/insee/sirene/etablissements/{siret}`)
* Données établissement diffusible (`/v3/insee/sirene/etablissements/diffusibles/{siret}`)
* Données siège social diffusible (`/v3/insee/sirene/unites_legales/diffusibles/{siren}/siege_social`)
* Données siège social (`/v3/insee/sirene/unites_legales/{siren}/siege_social`)
* Données unité légale (`/v3/insee/sirene/unites_legales/{siren}`)
* Données unité légale diffusible (`/v3/insee/sirene/unites_legales/diffusibles/{siren}`)
* Divers documents d'une association (`/v3/ministere_interieur/rna/associations/{siret_or_rna}/documents`)
* Données du RNA d'une association (`/v3/ministere_interieur/rna/associations/{siret_or_rna}`)
* Données association et documents (`/v4/ministere_interieur/api-asso/associations/{siren_or_rna}`)
* Données association et documents en open data (`/v4/ministere_interieur/api-asso/associations/open_data/{siren_or_rna}`)
* Conformité cotisations de sécurité sociale agricole (`/v3/msa/etablissements/{siret}/conformite_cotisations`)
* Certification d'ingénierie OPQIBI (`/v3/opqibi/unites_legales/{siren}/certification_ingenierie`)
* Conformité cotisations retraite bâtiment (`/v3/probtp/etablissements/{siret}/attestation_cotisations_retraite`)
* Conformité cotisations retraite complémentaire (`/v3/probtp/etablissements/{siret}/conformite_cotisations_retraite`)
* Certification Qualibat (`/v3/qualibat/etablissements/{siret}/certification_batiment`)
* Données du RNM d'une entreprise artisanale (`/v3/cma_france/rnm/unites_legales/{siren}`)
