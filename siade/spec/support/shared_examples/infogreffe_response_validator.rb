RSpec.shared_examples 'an Infogreffe response validator' do
  def infogreffe_envelope(content)
    '<SOAP-ENV:Envelope ' \
      "xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' " \
      "xmlns:SOAP-ENC='http://schemas.xmlsoap.org/soap/encoding/' " \
      "xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' " \
      "xmlns:xsd='http://www.w3.org/2001/XMLSchema'>" \
      '<SOAP-ENV:Body>' \
      '<ns0:getProduitsWebServicesXMLResponse ' \
      "xmlns:ns0='urn:local' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'> " \
      "<return xsi:type='xsd:string'>#{content}</return>" \
      '</ns0:getProduitsWebServicesXMLResponse>' \
      '</SOAP-ENV:Body>' \
      '</SOAP-ENV:Envelope>'
  end

  {
    temporary_credentials_error: '003 -CODE ABONNE OU MOT DE PASSE INVALIDE-',
    cant_generate_command: '014-IMPOSSIBILITE DE GENERER LA COMMANDE-'
  }.each do |kind, message|
    context "when Infogreffe answers #{message}" do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body: infogreffe_envelope(message)) }

      its('errors.first') { is_expected.to have_attributes(class: InfogreffeError, code: InfogreffeError.new(kind).code) }
    end
  end
end
