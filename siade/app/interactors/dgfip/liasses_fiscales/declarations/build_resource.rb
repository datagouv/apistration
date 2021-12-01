class DGFIP::LiassesFiscales::Declarations::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      id: entreprise_attributes['siren'],
      declarations: declarations_attributes.map { |declaration_attributes| build_declaration(declaration_attributes) }
    }
  end

  private

  def build_declaration(declaration_attributes)
    {
      date_declaration: declaration_attributes['date_declaration'],
      date_fin_exercice: declaration_attributes['fin_exercice']
    }
  end

  def declarations_attributes
    @declarations_attributes ||= json_body['declarations']
  end

  def entreprise_attributes
    @entreprise_attributes ||= json_body['entreprise']
  end

  def json_body
    @json_body ||= JSON.parse(response.body)
  end
end
