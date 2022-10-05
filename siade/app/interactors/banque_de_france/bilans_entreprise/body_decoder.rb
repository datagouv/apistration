module BanqueDeFrance::BilansEntreprise::BodyDecoder
  def body
    @body ||= Zlib::GzipReader.new(StringIO.new(response.body)).read
  end
end
