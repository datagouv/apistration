class MEN::ScolaritesPerimetre::Validators::RegionValidator
  VALID_CODES = YAML.load_file(Rails.root.join('config/data/men/codes_bcn_regions.yml')).freeze

  def self.valid?(values)
    values.all? { |v| VALID_CODES.key?(v) }
  end
end
