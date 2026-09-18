class APIParticulier::ErrorsNomenclatureController < ApplicationController
  include HandleErrorsNomenclature

  def self.api
    :particulier
  end
end
