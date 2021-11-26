class INPI::Brevets::BuildResourceCollection < BuildResourceCollection
  protected

  def resource_collection
    latest_brevets.map { |b| brevet_attributes(b) }
  end

  private

  def brevet_attributes(brevet)
    @fields = brevet['fields']

    {
      id: numero_publication,
      titre: find_field_from_key('TIT')['value'],
      date_publication: find_field_from_key('PUBD')['value'],
      date_depot: find_field_from_key('DEPD')['value'],
      code_zone: code_zone,
      numero_brevet: numero_brevet,
      categorie_publication: categorie_publication
    }
  end

  def latest_brevets
    json_body['results'].first(5)
  end

  def find_field_from_key(key)
    @fields.find { |f| f['name'] == key }
  end

  def numero_publication
    code_zone + numero_brevet + categorie_publication
  end

  def numero_publication_from_xml
    xml = find_field_from_key('PUBN')['value']

    @numero_publication_from_xml ||= Ox.load(xml, mode: :hash)
  end

  def code_zone
    numero_publication_from_xml[:country]
  end

  def numero_brevet
    numero_publication_from_xml[:'doc-number']
  end

  def categorie_publication
    numero_publication_from_xml[:kind]
  end
end
