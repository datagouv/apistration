class MEN::ScolaritesPerimetre::Validators::SirenIntercommunaliteValidator
  def self.valid?(values)
    values.all? { |v| Siren.new(v).valid? }
  end
end
