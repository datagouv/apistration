class INPI::Actes::BuildResourceCollection < BuildResourceCollection
  include INPI::ResourceHelpers

  protected

  def items
    json_body
  end

  def resource_attributes(item)
    {
      id: item['idFichier'],
      siren: item['siren'],
      code_greffe: code_greffe(item),
      date_depot: normalized_date(item['dateDepot']),
      nature_archive: item['natureArchive'],
      greffe_url: greffe_url(item)
    }
  end

  private

  def code_greffe(item)
    item['codeGreffe']
  end

  def greffe_url(item)
    "#{greffe_base_domain}?dataset=liste-des-greffes&q=code_greffe%3D#{code_greffe(item)}&facet=greffe&rows=1"
  end

  def greffe_base_domain
    'https://opendata.datainfogreffe.fr/api/records/1.0/search/'
  end
end
