class ANTSDossierImmatriculationSoapBuilder < ApplicationBuilder
  include PartialRendering

  attr_reader :immatriculation, :certificate, :private_key, :request_id

  def initialize(immatriculation:, certificate:, private_key:, request_id:)
    @immatriculation = immatriculation
    @certificate = certificate
    @private_key = private_key
    @request_id = request_id
  end

  def session_id
    @session_id ||= "#{request_id}----"
  end

  def saml_assertion
    @saml_assertion ||= build_saml_assertion
  end

  def assertion_variables
    @assertion_variables ||= compute_assertion_variables
  end

  def build_saml_assertion
    render_partial('_ants_saml_assertion.xml.erb', assertion_variables)
  end

  protected

  def template_name
    'ants_dossier_immatriculation_request.xml.erb'
  end

  private

  def compute_assertion_variables
    assertion_params.merge(digest: digest, signature: signature)
  end

  def assertion_params
    {
      assertion_id:,
      issue_instant: format_time(current_time),
      not_before: format_time(current_time),
      not_on_or_after: format_time(current_time + 600),
      idp_name:,
      code_partenaire:,
      code_concentrateur:,
      cert_der:
    }
  end

  def current_time
    @current_time ||= Time.now.utc
  end

  def assertion_id
    # TODO: Make this according to specs
    @assertion_id ||= "_#{SecureRandom.hex(16)}"
  end

  def format_time(time)
    time.strftime('%Y-%m-%dT%H:%M:%SZ')
  end

  def date_envoi
    current_time.strftime('%Y-%m-%dT%H:%M:%S')
  end

  def idp_name
    Siade.credentials[:ants_siv_idp_name]
  end

  def code_partenaire
    Siade.credentials[:ants_siv_code_partenaire]
  end

  def code_miat
    Siade.credentials[:ants_siv_code_miat]
  end

  def code_concentrateur
    Siade.credentials[:ants_siv_code_concentrateur]
  end

  def cert_der
    Base64.strict_encode64(certificate.to_der).gsub("\n", '')
  end

  def digest
    Base64.strict_encode64(Digest::SHA256.digest(assertion_canonicalized))
  end

  def assertion_doc
    # Build complete assertion with temporary signature values
    assertion_with_temp_signature = render_partial('_ants_saml_assertion.xml.erb', 
      assertion_params.merge(
        digest: 'TEMP_DIGEST_VALUE',
        signature: 'TEMP_SIGNATURE_VALUE'
      )
    )
    doc = Nokogiri::XML(assertion_with_temp_signature)
    # Apply enveloped-signature transform (remove Signature element)
    doc.xpath('//ds:Signature', 'ds' => 'http://www.w3.org/2000/09/xmldsig#').remove
    doc
  end

  def assertion_canonicalized
    @assertion_canonicalized ||= assertion_doc.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
  end

  def assertion_without_signature
    render_partial('_ants_saml_assertion_without_signature.xml.erb', assertion_params)
  end

  def signature
    Base64.strict_encode64(private_key.sign(openssl_digest, signed_info_canonicalized))
  end

  def signed_info_doc
    @signed_info_doc ||= Nokogiri::XML(signed_info_xml)
  end

  def signed_info_canonicalized
    @signed_info_canonicalized ||= signed_info_doc.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
  end

  def openssl_digest
    @openssl_digest ||= OpenSSL::Digest.new('SHA256')
  end

  def signed_info_xml
    render_partial('_ants_signed_info.xml.erb', { assertion_id:, digest: })
  end
end
