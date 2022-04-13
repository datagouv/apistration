module INPI::ResourceHelpers
  private

  def find_field_from_key(item, key)
    item['fields'].find { |f| f['name'] == key }
  end

  def limit
    context.params[:limit]
  end
end
