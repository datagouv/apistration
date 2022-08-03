class InfogreffeKbisSoapBuilder < ApplicationBuilder
  attr_reader :siren

  def initialize(siren)
    @siren = siren
  end

  protected

  def document_type
    'KB'
  end

  def infogreffe_code_abonne
    Siade.credentials[:infogreffe_code_abonne]
  end

  def infogreffe_mot_passe
    Siade.credentials[:infogreffe_mot_passe]
  end

  def template_name
    'infogreffe_kbis_entreprise_request.xml.erb'
  end
end
