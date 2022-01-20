require 'yaml'
require 'net/http'
require 'openssl'
require 'colorize'

# Check README for usage

@host = ARGV[0] || "https://entreprise.api.gouv.fr"
@endpoints = !ARGV[1].nil? ? ARGV[1].split(',').map(&:to_i) : []

if @host =~ /sandbox/
  token_to_read = '.token.sandbox'
elsif @host =~ /staging/
  token_to_read = '.token.staging'
else
  token_to_read = '.token.production'
end

begin
  @jwt = File.read(token_to_read)
rescue Errno::ENOENT
  begin
    @jwt = File.read('.token')
  rescue Errno::ENOENT
    print ".token or #{token_to_read} should exists\n"
    exit 1
  end
end

@default_query_params = {
  context:   'Test',
  recipient: '13002526500013',
  object:    'Pré mise en production',
}
@request_options = {
  use_ssl:     true,
  verify_mode: OpenSSL::SSL::VERIFY_PEER,
}

endpoints = <<STR
---
- name: Bilans Entreprises Banque de France
  http_path: '/v2/bilans_entreprises_bdf/775670417'

- name: Liasses fiscales (complete)
  http_path: '/v2/liasses_fiscales_dgfip/2016/complete/301028346'

- name: Liasses fiscales (déclaration)
  http_path: '/v2/liasses_fiscales_dgfip/2016/declarations/301028346'

- name: Liasses fiscales (dictionnaire)
  http_path: '/v2/liasses_fiscales_dgfip/2016/dictionnaire'

- name: Cotisations MSA
  http_path: '/v2/cotisations_msa/81104725700019'

- name: Eligibilité cotisation retraite ProBTP
  http_path: '/v2/eligibilites_cotisation_retraite_probtp/43841606700017'

- name: Attestations cotisations retraite ProBTP
  http_path: '/v2/attestations_cotisation_retraite_probtp/43841606700017'

- name: Entreprise
  http_path: '/v2/entreprises/418166096'

- name: Extraits RCS (Infogreffe)
  http_path: '/v2/extraits_rcs_infogreffe/418166096'

- name: Etablissements
  http_path: '/v2/etablissements/41816609600069'

- name: Exercices
  http_path: '/v2/exercices/53930425300013'

- name: Attestations agefiph
  http_path: '/v2/attestations_agefiph/48146131700036'

- name: Attestations fiscales
  http_path: '/v2/attestations_fiscales_dgfip/532010576'

- name: Attestations sociales
  http_path: '/v2/attestations_sociales_acoss/418166096'

- name: Effectifs annuels
  http_path: '/v2/effectifs_annuels_acoss_covid/829423052'

- name: Effectifs mensuels (entreprise)
  http_path: '/v2/effectifs_mensuels_acoss_covid/2020/02/entreprise/552032534'

- name: Effectifs mensuels (établissement)
  http_path: '/v2/effectifs_mensuels_acoss_covid/2020/02/etablissement/55203253400646'

- name: Conventions Collectives
  http_path: '/v2/conventions_collectives/82161143100015'

- name: Certificats Qualibat
  http_path: '/v2/certificats_qualibat/78824266700020'

- name: Entreprises artisanales CMA France
  http_path: '/v2/entreprises_artisanales_cma/301123626'

- name: Certificats CNETP
  http_path: '/v2/certificats_cnetp/542036207'

- name: Certificats OPQIBI
  http_path: '/v2/certificats_opqibi/309103877'

- name: Associations
  http_path: '/v2/associations/W604004799'

- name: Documents associations
  http_path: '/v2/documents_associations/77571979202585'

- name: Extraits courts INPI
  http_path: '/v2/extraits_courts_inpi/542065479'

- name: Cartes professionnelles FNTP
  http_path: '/v2/cartes_professionnelles_fntp/562077503'

- name: Certificats RGE ADEME
  http_path: '/v2/certificats_rge_ademe/50044188600016'

- name: Certificats Agence BIO
  http_path: '/v2/certificats_agence_bio/48311105000025'

- name: Actes INPI
  http_path: '/v2/actes_inpi/788242667'

- name: Bilans INPI
  http_path: '/v2/bilans_inpi/788242667'

- name: Etablissements (INSEE v3)
  http_path: '/v2/etablissements/41816609600069'
  extra_http_query:
    with_insee_v3: true

- name: Entreprise (INSEE v3)
  http_path: '/v2/entreprises/418166096'
  extra_http_query:
    with_insee_v3: true

- name: EORI DGDDI (Douane)
  http_path: '/v2/eori_douanes/FR16002307300010'

- name: '[V3] ACOSS Attestations sociales'
  http_path: '/v3/acoss/attestations_sociales/418166096'

- name: '[V3] DGDDI EORI'
  http_path: '/v3/dgddi/eoris/FR16002307300010'

- name: '[V3] INPI Actes'
  http_path: '/v3/inpi/actes/542065479'

- name: '[V3] INPI Brevets'
  http_path: '/v3/inpi/brevets/542065479'

- name: '[V3] INPI Marques'
  http_path: '/v3/inpi/marques/542065479'

- name: '[V3] INPI Modeles'
  http_path: '/v3/inpi/modeles/542065479'

- name: '[V3] INSEE Etablissements'
  http_path: '/v3/insee/sirene/etablissements/30613890002979'

- name: '[V3] INSEE Etablissements Adresse'
  http_path: '/v3/insee/sirene/etablissements/30613890002979/adresse'

- name: '[V3] INSEE Unites Legales'
  http_path: '/v3/insee/sirene/unites_legales/306138900'

- name: '[V3] INSEE Unites Legales Diffusibles'
  http_path: '/v3/insee/sirene/unites_legales/diffusibles/306138900'

- name: '[V3] INSEE Unites Legales Siege'
  http_path: '/v3/insee/sirene/unites_legales/306138900/siege'

- name: '[V3] MI Associations'
  http_path: '/v3/mi/associations/77571979202650'

- name: '[V3] ProBTP Attestations cotisations retraite'
  http_path: '/v3/probtp/attestations_cotisations_retraite/43841606700017'

- name: '[V3] FNMS Conventions collectives'
  http_path: '/v3/fabrique_numerique_ministeres_sociaux/conventions_collectives/82161143100015'

- name: '[V3] RNM Entreprises'
  http_path: '/v3/rnm/entreprises/301123626'

STR

def test_endpoint(endpoint, index)
  name = endpoint['name']
  route = endpoint['http_path']

  uri = URI("#{@host}#{route}").tap do |u|
    query_params = @default_query_params.dup

    if endpoint['extra_http_query']
      query_params.merge!(endpoint['extra_http_query'])
    end

    u.query = URI.encode_www_form(query_params)
  end

  response = Net::HTTP.start(uri.hostname, uri.port, @request_options) do |http|
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@jwt}".gsub("\n", '')

    http.read_timeout = 30
    http.open_timeout = 30

    http.request request
  end

  if response.code == '200'
    status = "OK".green
  elsif response.code == '401'
    print "Token is not valid for this host! Abort.\n".red
    exit 2
  else
    status = "NOK ( #{response.code} )".red
  end
rescue Net::ReadTimeout
  status = "NOK ( timeout from client )".red
ensure
  print "[#{index}] Endpoint '#{name}' ( #{route} ): #{status}\n"
  print "Payload: #{response.body}\n\n" if ENV['DEBUG']
end

print "## Test endpoints on #{@host}\n\n"

YAML.load(endpoints).each_with_index do |endpoint, index|
  if @endpoints.empty? || @endpoints.include?(index+1)
    test_endpoint(endpoint, index+1)
    sleep 1
  end
end
