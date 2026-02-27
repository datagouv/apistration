class MEN::Scolarites::Validators::DepartementValidator
  VALID_CODES = YAML.load_file(Rails.root.join('config/data/men/codes_bcn_departements.yml')).freeze

  def self.valid?(values)
    values.all? { |v| VALID_CODES.key?(v) }
  end
end
