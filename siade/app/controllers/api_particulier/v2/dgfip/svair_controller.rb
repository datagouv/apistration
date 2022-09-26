class APIParticulier::V2::DGFIP::SVAIRController < APIParticulierController
  def show
    authorize(*scopes)

    organizer = retrieve_payload_data(::DGFIP::SVAIR, cache: true, cache_key:, expires_in: 1.hour)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      tax_number: params[:numeroFiscal],
      tax_notice_number: params[:referenceAvis]
    }
  end

  def cache_key
    "dgfip/svair:#{organizer_params.to_query}"
  end

  # rubocop:disable Metrics/MethodLength
  def scopes
    %i[
      dgfip_declarant1_nom
      dgfip_declarant1_nom_naissance
      dgfip_declarant1_prenoms
      dgfip_declarant1_date_naissance
      dgfip_declarant2_nom
      dgfip_declarant2_nom_naissance
      dgfip_declarant2_prenoms
      dgfip_declarant2_date_naissance
      dgfip_date_recouvrement
      dgfip_date_etablissement
      dgfip_adresse_fiscale_taxation
      dgfip_adresse_fiscale_annee
      dgfip_nombre_parts
      dgfip_nombre_personnes_a_charge
      dgfip_situation_familiale
      dgfip_revenu_brut_global
      dgfip_revenu_imposable
      dgfip_impot_revenu_net_avant_corrections
      dgfip_montant_impot
      dgfip_revenu_fiscal_reference
      dgfip_annee_impot
      dgfip_annee_revenus
      dgfip_erreur_correctif
      dgfip_situation_partielle
    ]
  end
  # rubocop:enable Metrics/MethodLength

  def extract_http_code(organizer)
    if at_least_one_error_kind_of?(:forbidden, organizer)
      :bandwidth_limit_exceeded
    else
      super
    end
  end

  def format_bandwidth_limit_exceeded_error(_error)
    {
      error: 'rate_limited',
      reason: 'DGFIP error rate limit exceeded',
      message: "Le fournisseur de donnée a rejeté la demande en raison d'un trop grand nombre d'échecs antérieurs."
    }
  end
end
