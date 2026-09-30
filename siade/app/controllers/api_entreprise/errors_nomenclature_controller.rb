class APIEntreprise::ErrorsNomenclatureController < ApplicationController
  include HandleErrorsNomenclature

  def self.api
    :entreprise
  end
end
