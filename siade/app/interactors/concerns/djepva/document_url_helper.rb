module DJEPVA::DocumentUrlHelper
  def build_valid_document_url(url)
    if url.start_with?('http://localhost:8181/services')
      url.gsub('http://localhost:8181/services', "#{Siade.credentials[:mi_domain]}/apim/api-asso")
    else
      url
    end
  end
end
