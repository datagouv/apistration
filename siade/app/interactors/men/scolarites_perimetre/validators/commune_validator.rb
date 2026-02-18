class MEN::ScolaritesPerimetre::Validators::CommuneValidator
  PATTERN = /\A([013-9]\d|2[AB1-9])\d{3}\z/

  def self.valid?(values)
    values.all? { |v| v.match?(PATTERN) }
  end
end
