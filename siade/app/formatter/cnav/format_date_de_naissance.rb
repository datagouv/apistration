class CNAV::FormatDateDeNaissance < ApplicationFormatter
  def initialize(year, month, day)
    @year = year.to_i
    @month = month.to_i
    @day = day.to_i

    @day = 0 if @year.zero? || @month.zero?
    @month = 0 if @year.zero?
  end

  def format
    Kernel.format('%<year>04d-%<month>02d-%<day>02d', year: @year, month: @month, day: @day)
  end
end
