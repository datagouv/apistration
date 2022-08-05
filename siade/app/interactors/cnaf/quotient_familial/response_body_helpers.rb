module CNAF::QuotientFamilial::ResponseBodyHelpers
  private

  def data
    Nokogiri.XML(xml_without_mime.css('fluxRetour').children.text)
  end

  def xml_without_mime
    @xml_without_mime ||= Nokogiri.XML(response.body.split("\n")[4..].join("\n").strip)
  end
end
