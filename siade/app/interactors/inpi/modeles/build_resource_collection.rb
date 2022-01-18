class INPI::Modeles::BuildResourceCollection < BuildResourceCollection
  protected

  def items
    latest_modeles
  end

  def items_meta
    {
      count: json_body['metadata']['count']
    }
  end

  def resource_attributes(item)
    {
      id: id(item),
      numero_depot: numero_depot(item),
      titre: titre(item),
      total_representations: total_representations(item),
      deposant: deposant(item),
      date_depot: date_depot(item),
      date_publication: date_publication(item),
      classe: classe(item),
      reference: reference(item),
      notice_url: notice_url(item)
    }
  end

  private

  def latest_modeles
    json_body['results'].first(limit)
  end

  def id(item)
    item['documentId']
  end

  def notice_url(item)
    item['xml']['href']
  end

  def numero_depot(item)
    find_field_from_key(item, 'DesignApplicationNumber')['value']
  end

  def titre(item)
    find_field_from_key(item, 'DesignTitle')['value']
  end

  def total_representations(item)
    total = find_field_from_key(item, 'TotalRepresentationSheet')['value']

    total.to_i
  end

  def deposant(item)
    find_field_from_key(item, 'DEPOSANT')['value']
  end

  def date_depot(item)
    date = find_field_from_key(item, 'DesignApplicationDate')['value']

    normalized_date(date)
  end

  def date_publication(item)
    date = find_field_from_key(item, 'PublicationDate')['value']

    normalized_date(date)
  end

  def classe(item)
    find_field_from_key(item, 'ClassNumber')['value']
  end

  def reference(item)
    find_field_from_key(item, 'DesignReference')['value']
  end

  def find_field_from_key(item, key)
    item['fields'].find { |f| f['name'] == key }
  end

  def normalized_date(date)
    date.to_time.strftime('%Y-%m-%d')
  end

  def limit
    context.params[:limit]
  end
end
