class INPI::Brevets::BuildResourceCollection < BuildResourceCollection
  protected

  def items
    latest_brevets.map { |b| resource_attributes(b) }
  end

  def items_meta
    {
      count: json_body['metadata']['count']
    }
  end

  def resource_attributes(item)
    @item = item

    {
      id: numero_publication,
      titre: find_field_from_key('TIT')['value'],
      date_publication: date_publication,
      date_depot: date_depot,
      code_zone: code_zone,
      numero_brevet: numero_brevet,
      categorie_publication: categorie_publication
    }
  end

  private

  def latest_brevets
    json_body['results'].first(limit)
  end

  def fields
    @fields ||= @item['fields']
  end

  def find_field_from_key(key)
    fields.find { |f| f['name'] == key }
  end

  def numero_publication_hash
    @numero_publication_hash ||= Ox.load(numero_publication_as_xml, mode: :hash)
  end

  def numero_publication_as_xml
    @numero_publication_as_xml ||= find_field_from_key('PUBN')['value']
  end

  def code_zone
    numero_publication_hash[:country]
  end

  def numero_brevet
    numero_publication_hash[:'doc-number']
  end

  def categorie_publication
    numero_publication_hash[:kind]
  end

  def numero_publication
    code_zone + numero_brevet + categorie_publication
  end

  def date_publication
    date = find_field_from_key('PUBD')['value']

    normalized_date(date)
  end

  def date_depot
    date = find_field_from_key('DEPD')['value']

    normalized_date(date)
  end

  def normalized_date(date)
    date.to_time.strftime('%Y-%m-%d')
  end

  def limit
    context.params[:limit]
  end
end
