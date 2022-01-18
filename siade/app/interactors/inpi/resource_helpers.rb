module INPI::ResourceHelpers
  private

  def normalized_date(date)
    date.to_time.strftime('%Y-%m-%d')
  end

  def find_field_from_key(item, key)
    item['fields'].find { |f| f['name'] == key }
  end

  def limit
    context.params[:limit]
  end
end
