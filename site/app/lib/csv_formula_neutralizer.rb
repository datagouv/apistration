require 'csv'

module CsvFormulaNeutralizer
  FORMULA_TRIGGERS = ['=', '+', '-', '@', "\t", "\r"].freeze

  def self.call(field)
    field.try(:start_with?, *FORMULA_TRIGGERS) ? "'#{field}" : field
  end

  def self.write_converters
    [method(:call).to_proc]
  end
end
