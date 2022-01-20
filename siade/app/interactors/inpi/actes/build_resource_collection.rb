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
      denomination_sociale: item['denominationSociale'],
      code_greffe: item['codeGreffe'],
      date_depot: normalized_date(item['dateDepot']),
      nature_archive: item['natureArchive']
    }
  end
end
