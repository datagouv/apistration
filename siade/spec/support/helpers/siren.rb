# rubocop:disable Metrics/MethodLength
def valid_siren(sample_type = :default)
  samples = {
    default: valid_siret.first(9),
    cnetp: '433604196',
    fntp: '562077503',
    acoss: '511101651',
    octo: valid_siret(:octo).first(9),
    opqibi: '309103877',
    opqibi_with_probatoire: '434717997',
    extrait_rcs: '418166096',
    extrait_rcs_personne_physique: '403860265',
    insee_entreprise: '552032534',
    dgfip: valid_siret(:dgfip).first(9),
    liasse_fiscale: '301028346',
    peugeot: '542065479',
    inpi: '542065479',
    inpi_pdf: '393463187',
    insee_entreprise_legacy: valid_siret(:octo).first(9),
    bilan_entreprise_bdf: la_poste_siren,
    rnm_cma: '301123626',
    recipient: valid_siret(:recipient).first(9)
  }

  samples[sample_type]
end
# rubocop:enable Metrics/MethodLength

def sirens_insee_v3
  {
    active_GE: '306138900',
    active_GE_bis: '500569405',
    active_AE: '412288383',
    etranger: '487596603',
    with_enseigne_siren: '130015522',
    address_complete: '331457648',
    ceased: ceased_siren
  }
end

def redirected_siren
  redirected_siret.first(9)
end

def not_found_siren(sample_type = nil)
  not_found_siret(sample_type).first(9)
end

def invalid_siren
  invalid_siret.first(9)
end

def non_existent_siren
  '000000000'
end

def not_a_siren
  'bull'
end

def danone_siren
  danone_siret.first(9)
end

def ceased_siren
  closed_siret.first(9)
end

def non_diffusable_siren
  non_diffusable_siret.first 9
end

def old_non_diffusable_siren
  old_non_diffusable_siret.first 9
end

def confidential_siren(sample_type)
  confidential_siret(sample_type).first 9
end

def association_siren
  association_siret.first(9)
end

def la_poste_siren
  '356000000'
end
