RSpec.describe ANTSDossierImmatriculationSoapBuilder do
  subject(:builder) { described_class.new(immatriculation:, certificate:, private_key:, ants_request_id:) }

  let(:immatriculation) { 'AA-123-AA' }
  let(:ants_request_id) { 'req_test-request-123' }

  let(:private_key) do
    OpenSSL::PKey::RSA.new(File.read('spec/fixtures/ssl/certificat.key'))
  end

  let(:certificate) do
    OpenSSL::X509::Certificate.new(File.read('spec/fixtures/ssl/certificat.crt'))
  end

  before do
    Timecop.freeze(Time.new(2025, 1, 15, 10, 30, 0, '+00:00'))
    allow(SecureRandom).to receive(:hex).with(16).and_return('0123456789abcdef0123456789abcdef')
  end

  after do
    Timecop.return
  end

  describe '#render' do
    it 'generates the complete SOAP XML for ANTS request' do
      rendered_xml = builder.render

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
        <ds:SignatureValue>EFQOgmt2yMeGb01mvlQq0SK7HyGJSZK/qP9j+yQkFEWhBNDyMCzb5Pi8/tax+RrG7kOj9eRaRlah0peiqCmun1b2FtgbvzfuG3gA5hbHZsYr2upLUakYqvYC2HEL1ilH4Pfjexzy+O8Yx08oivCn+wKOJImeTxCJvLByM8B3vXR/B4JLb4G+A/f/zlbD522X1MROzqgCyVPviz8p3p4W4yuXZWZ1Vqge74ECIxoERNJVO9mUlfXl4c9boAWPErvNpeCHxgjJ3fz+WMmWVH/e7oH8lZBZ1dPzLLvcgLR292FyYrUWYINSA4Lan7A0G6BKtLUEhgdRfhyWS1k7NqmZcQ==</ds:SignatureValue>
        <ds:KeyInfo>
        <ds:X509Data>
        <ds:X509Certificate>MIIDrTCCApWgAwIBAgIUBsyCFwj45AFEZd7fKESr7NO/QLcwDQYJKoZIhvcNAQELBQAwZjELMAkGA1UEBhMCRlIxDjAMBgNVBAgMBVBhcmlzMQ4wDAYDVQQHDAVQYXJpczENMAsGA1UECgwEVGVzdDENMAsGA1UECwwEVGVzdDEZMBcGA1UEAwwQdGVzdC5leGFtcGxlLmNvbTAeFw0yNTA4MDgxMTU0MjRaFw0yNjA4MDgxMTU0MjRaMGYxCzAJBgNVBAYTAkZSMQ4wDAYDVQQIDAVQYXJpczEOMAwGA1UEBwwFUGFyaXMxDTALBgNVBAoMBFRlc3QxDTALBgNVBAsMBFRlc3QxGTAXBgNVBAMMEHRlc3QuZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDEpkPEyo5JGmxezgtpMhdJt62tNTNthF1UV6CVVq36TFj5KPniv/aL3hvCj65zNGf5gx8N6yv/5+5ES4LMSJvv2vi5mkhJ+acwdtRz/TlDufELoQL+yLaJNov6R1WUbjK07lsfK6trw3M6dZ8DxZg3FoZQr5ud2ZUo4kHXC2CvVpA3yb34PQsXr0kSaIXFT6t6MTqntGlwuGfQGFdnSfO9Fggo0XVoKH4sFf4UzEsZpFcy1pGbddvAEtvWWcKWEhsEHG0HShCbw4eR09mXePelTEiMidwNV5jw/JQYqLXoQ3dy6mHaeBM2axOaRLMUh/39WVRTuIVI0EudGDNUGVeFAgMBAAGjUzBRMB0GA1UdDgQWBBT/PiniqvCBOkIAUARCLFR/TxzjkTAfBgNVHSMEGDAWgBT/PiniqvCBOkIAUARCLFR/TxzjkTAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQA1FnRAaSoeZ/OuJzNapBofehNsXB9FRViWp4toqIbACMEPe9JtWVk9qKIQqsjCiBcGQkmC22L4PXXaSzgWT1c1Yi82KZO2QYDC6K4x9VPHqGd3jx4RYCutayeiXK4tgIXghXUrCC7J4hPFhy+Vg+FSHVKTnwTANCh0gvAOEECftnLJqbW11XR2LUdc7WkXyK7fmP+KP4/9oPUeOX6kRVV2Fa4mFDlyxanOYBHzIs2ZtGtlc11KFeKV9TzZC6SA9FvV6rx2amL22txkimQjFiN69kEA7wZCkCmQRpUWZf+MHzXO2Yjzdb8lyQnT/H+8+TgMmkBy8vnOTFzBQZ7JtauO</ds:X509Certificate>
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
        <ns1:numero_session>req_test-request-123</ns1:numero_session>
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

      expect(rendered_xml).to eq(expected_xml)
    end
  end
end
