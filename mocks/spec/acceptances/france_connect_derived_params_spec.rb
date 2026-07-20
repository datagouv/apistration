# Keys a real FranceConnect-derived request (V3+ providers only) can actually produce —
# transcribed from siade/app/interactors/**/make_request.rb. A fixture param outside this
# list is a typo that can never match a real request and silently 404s instead.
ALLOWED_FRANCE_CONNECT_KEYS = %w[
  nomNaissance prenoms anneeDateNaissance moisDateNaissance jourDateNaissance sexeEtatCivil
  codeCogInseeCommuneNaissance codeCogInseePaysNaissance annee mois campaignYear
  immatriculation
].freeze

RSpec.describe 'FranceConnect-derived fixture params' do
  fc_fixture_paths = Dir[File.join(root_path, 'payloads', '*')]
    .select { |path| File.directory?(path) && File.basename(path).end_with?('_with_france_connect') }
    .flat_map { |dir| Dir[File.join(dir, '*.y*ml')] }

  fc_fixture_paths.each do |payload_path|
    operation_id = File.basename(File.dirname(payload_path))
    basename = File.basename(payload_path)

    it "#{operation_id}/#{basename} only uses keys a real FranceConnect request can produce" do
      params = YAML.load_file(payload_path)['params'] || {}
      extra_keys = params.keys.map(&:to_s) - ALLOWED_FRANCE_CONNECT_KEYS

      expect(extra_keys).to be_empty,
        "#{basename} has params no FranceConnect-derived request can ever produce: " \
        "#{extra_keys.join(', ')}. Likely a typo — check against ALLOWED_FRANCE_CONNECT_KEYS " \
        'in this spec, and the provider\'s mocking_params(_v2) in siade if it\'s a legitimately new key.'
    end
  end
end
