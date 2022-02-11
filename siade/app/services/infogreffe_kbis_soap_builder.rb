class InfogreffeKbisSoapBuilder
  attr_reader :siren

  def initialize(siren)
    @siren = siren
  end

  def render
    renderer.result(binding)
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

  private

  def renderer
    @renderer ||= ERB.new(File.read(template_path))
  end

  def template_path
    Rails.root.join('app/templates/infogreffe_kbis_entreprise_request.xml.erb')
  end
end
