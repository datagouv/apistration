class CNAFQuotientFamilialSoapBuilder < ApplicationBuilder
  attr_reader :postal_code, :beneficiary_number

  def initialize(postal_code, beneficiary_number)
    @postal_code = postal_code
    @beneficiary_number = beneficiary_number
  end

  protected

  def template_name
    'cnaf_quotient_familial_request.xml.erb'
  end
end
