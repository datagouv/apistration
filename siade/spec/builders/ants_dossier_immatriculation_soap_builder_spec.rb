RSpec.describe ANTSDossierImmatriculationSoapBuilder do
  subject(:builder) { described_class.new(immatriculation:, certificate:, private_key:, request_id:) }

  let(:immatriculation) { 'AA-123-AA' }
  let(:certificate) { instance_double(OpenSSL::X509::Certificate) }
  let(:private_key) { instance_double(OpenSSL::PKey::RSA) }
  let(:request_id) { 'test-request-123' }

  before do
    Timecop.freeze(Time.new(2025, 1, 15, 10, 30, 0, '+00:00'))

    allow(certificate).to receive(:to_der).and_return('mock_certificate_der_content')
    allow(private_key).to receive(:sign).with(
      instance_of(OpenSSL::Digest),
      instance_of(String)
    ).and_return('mock_signature_bytes')

    allow(Base64).to receive(:strict_encode64).and_call_original
    allow(Base64).to receive(:strict_encode64).with('mock_certificate_der_content').and_return('bW9ja19jZXJ0aWZpY2F0ZV9kZXJfY29udGVudA==')
    allow(Base64).to receive(:strict_encode64).with('mock_signature_bytes').and_return('bW9ja19zaWduYXR1cmVfYnl0ZXM=')

    allow(SecureRandom).to receive(:hex).with(16).and_return('0123456789abcdef0123456789abcdef')
  end

  after do
    Timecop.return
  end

  describe '#render' do
    it 'generates the correct SOAP envelope structure' do
      expected_xml = <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:ns1="http://siv.mi.fr/DefinitionsServices/2007-06">
        <env:Header>
        <wsse:Security actor="" mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
        <saml:Assertion ID="_0123456789abcdef0123456789abcdef" IssueInstant="2025-01-15T10:30:00Z" Version="2.0" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">
        <saml:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">ants_siv_idp_name</saml:Issuer>
        <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
        <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
        <ds:Reference URI="#_0123456789abcdef0123456789abcdef">
        <ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
        <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
        </ds:Transforms>
        <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
        <ds:DigestValue>1gn32iYClqABmJS48aULv0t9huOvuDZI5bLufiOSA88=</ds:DigestValue>
        </ds:Reference>
        </ds:SignedInfo>
        <ds:SignatureValue>bW9ja19zaWduYXR1cmVfYnl0ZXM=</ds:SignatureValue>
        <ds:KeyInfo>
        <ds:X509Data>
        <ds:X509Certificate>bW9ja19jZXJ0aWZpY2F0ZV9kZXJfY29udGVudA==</ds:X509Certificate>
        </ds:X509Data>
        </ds:KeyInfo>
        </ds:Signature>
        <saml:Subject>
        <saml:NameID Format="urn:oasis:names:tc:SAML:2.0:nameid-format:unspecified">ants_siv_idp_name</saml:NameID>
        <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:sender-vouches"/>
        </saml:Subject>
        <saml:Conditions NotBefore="2025-01-15T10:30:00Z" NotOnOrAfter="2025-01-15T10:40:00Z"/>
        <saml:AuthnStatement AuthnInstant="2025-01-15T10:30:00Z">
        <saml:AuthnContext>
        <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:XMLDSig</saml:AuthnContextClassRef>
        </saml:AuthnContext>
        </saml:AuthnStatement>
        <saml:AttributeStatement>
        <saml:Attribute Name="CodePartenaire" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue>ants_siv_code_concentrateur</saml:AttributeValue>
        </saml:Attribute>
        </saml:AttributeStatement>
        </saml:Assertion>
        </wsse:Security>
        </env:Header>
        <env:Body>
        <ns1:req_consulter_dossier xmlns:ns1="http://siv.mi.fr/DefinitionsServices/2007-06">
        <ns1:control>
        <ns1:code_partenaire>ants_siv_code_partenaire</ns1:code_partenaire>
        <ns1:code_miat>ants_siv_code_miat</ns1:code_miat>
        <ns1:type_operation>Consultation Dossier</ns1:type_operation>
        <ns1:numero_session>test-request-123----</ns1:numero_session>
        <ns1:date_envoi>2025-01-15T10:30:00</ns1:date_envoi>
        </ns1:control>
        <ns1:requete>
        <ns1:mode_appel>L</ns1:mode_appel>
        <ns1:informations>
        <ns1:num_immat>AA-123-AA</ns1:num_immat>
        </ns1:informations>
        </ns1:requete>
        </ns1:req_consulter_dossier>
        </env:Body>
        </env:Envelope>
      XML

      expect(builder.render).to eq(expected_xml)
    end
  end
end
