class INPI::Brevets::BuildResourceCollection < BuildResourceCollection
  include INPI::ResourceHelpers

  protected

  def items
    latest_brevets
  end

  def items_meta
    {
      count: json_body['metadata']['count']
    }
  end

  def resource_attributes(item)
    {
      numero_publication: numero_publication(item),
      titre: titre(item),
      date_publication: date_publication(item),
      date_depot: date_depot(item),
      code_zone: code_zone(item),
      numero_brevet: numero_brevet(item),
      categorie_publication: categorie_publication(item)
    }
  end

  private

  def latest_brevets
    json_body['results'].first(limit)
  end

  def find_field_from_key(item, key)
    fields = item['fields']

    fields.find { |f| f['name'] == key }
  end

  def numero_publication_hash(item)
    Ox.load(numero_publication_as_xml(item), mode: :hash)
  end

  def numero_publication_as_xml(item)
    find_field_from_key(item, 'PUBN')['value']
  end

  def code_zone(item)
    numero_publication_hash(item)[:country]
  end

  def numero_brevet(item)
    numero_publication_hash(item)[:'doc-number']
  end

  def categorie_publication(item)
    numero_publication_hash(item)[:kind]
  end

  def numero_publication(item)
    code_zone(item) + numero_brevet(item) + categorie_publication(item)
  end

  def titre(item)
    find_field_from_key(item, 'TIT')['value']
  end

  def date_publication(item)
    date = find_field_from_key(item, 'PUBD')['value']

    normalized_date(date)
  end

  def date_depot(item)
    date = find_field_from_key(item, 'DEPD')['value']

    normalized_date(date)
  end
end
