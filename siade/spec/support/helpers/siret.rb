# rubocop:disable Metrics/MethodLength
def valid_siret(sample_type = nil)
  sample_type ||= :default

  samples = {
    default: '78951073200017',
    carif_oref: '81841109200013',
    cibtp: '81125785600021',
    rna: '42135938100033',
    octo: '41816609600069',
    rge_ademe: '50530961700023',
    qualibat: '89785620900019',
    probtp: '73582032600040',
    msa_pending: '81104725700019',
    msa: '38069910800011',
    insee_etablissement: '55203253400646',
    insee_etablissement_legacy: '41816609600069',
    insee_etablissement_with_enseigne: '52909916000028',
    conventions_collectives: '82161143100015',
    dgfip: '78951073200017',
    exercice: '55203253400646',
    recipient: '91978102100010',
    qualifelec: '78951073200017'
  }

  samples[sample_type]
end

def sirets_insee_v3
  {
    active_AE: '41228838300018',
    arrondissement_marseille: '31071023100021',
    active_GE: '30613890002979',
    active_association: '80171927900011',
    active_GE_ss: '50056940503239',
    artisan: '45375145500024',
    address_complete: '33145764800011',
    address_poor: '03873454700011', # 15ème arrondissement Paris
    with_enseigne_siret: '50221447100042',
    etranger_1: '48758523400031',
    etranger_2: '48758547300019',
    etranger_3: '48759660300018',
    etranger_4: '48760118900011',
    closed: closed_siret,
    successions: '30006240940040'
  }
end

def not_found_siret(sample_type = nil)
  sample_type ||= :default

  samples = {
    default: non_existent_siret,
    cibtp: '77566487304147',
    qualibat: danone_siret,
    probtp: '41816609600069',
    rge_ademe: '82525962500028',
    msa: '43409355500010',
    opqibi: '77568501900587',
    insee_etablissement: '41816609600051',
    insee_entreprise: '17830254300000',
    insee_etablissement_legacy: '41816609600077', # Valid format built from siren octo and compatible yet inexistent nic
    extrait_rcs: '43226899300032',
    conventions_collectives: '82525962500028',
    inpi: '43226899300032',
    rnm_cma: '87786242500015'
  }

  samples[sample_type]
end
# rubocop:enable Metrics/MethodLength

def redirected_siret
  '53222169400013'
end

def eligible_siret(sample_type)
  samples = {
    probtp: '34909797200021'
  }
  samples[sample_type]
end

def non_eligible_siret(sample_type)
  samples = {
    probtp: '55204599900828'
  }
  samples[sample_type]
end

def valid_nic
  '00017'
end

def invalid_siret
  '10000000000001'
end

def non_existent_siret
  '00000000000000'
end

def non_diffusable_siret
  '78951073200017'
end

def old_non_diffusable_siret
  '82780106900010'
end

def confidential_siret(sample_type)
  samples = {
    non_diffusable_ceased: '78951073200025',
    gendarmerie_limousin: '15700033200013'
  }

  samples[sample_type]
end

def out_of_scope_dgfip
  '50278496000036'
end

def not_a_siret
  'bullshit'
end

def danone_siret
  '55203253400646'
end

def closed_siret
  '49081738400020'
end

def association_siret
  '19590183000024'
end
