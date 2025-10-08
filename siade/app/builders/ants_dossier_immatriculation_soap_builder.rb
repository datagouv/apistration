class ANTSDossierImmatriculationSoapBuilder < ApplicationBuilder
  include PartialRendering

  attr_reader :immatriculation, :certificate, :private_key, :ants_request_id

  def initialize(immatriculation:, certificate:, private_key:, ants_request_id:)
    @immatriculation = immatriculation
    @certificate = certificate
    @private_key = private_key
    @ants_request_id = ants_request_id
  end

  def render
    assertion_with_temp_signature = build_saml_with_temporary_signature
    @assertion_digest = build_digest(assertion_with_temp_signature)
    @signature_value = build_signature_from_digest(@assertion_digest)
    super
  end

  def saml_assertion
    @saml_assertion ||= render_partial('_ants_saml_assertion.xml.erb', assertion_variables)
  end

  protected

  def template_name
    'ants_dossier_immatriculation_request.xml.erb'
  end

  private

  def build_saml_with_temporary_signature
    render_partial('_ants_saml_assertion.xml.erb',
      assertion_params.merge(
        digest: 'TEMP_DIGEST_VALUE',
        signature: 'TEMP_SIGNATURE_VALUE'
      ))
  end

  def build_digest(assertion_with_temp_signature)
    doc = Nokogiri::XML(assertion_with_temp_signature)
    doc.xpath('//ds:Signature', 'ds' => 'http://www.w3.org/2000/09/xmldsig#').remove
    canonicalized = doc.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
    Base64.strict_encode64(Digest::SHA256.digest(canonicalized))
  end

  def build_signature_from_digest(assertion_digest)
    signed_info_xml = render_partial('_ants_signed_info.xml.erb', { assertion_id:, digest: assertion_digest })
    signed_info_doc = Nokogiri::XML(signed_info_xml)
    signed_info_canonicalized = signed_info_doc.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
    digest = OpenSSL::Digest.new('SHA256')
    Base64.strict_encode64(private_key.sign(digest, signed_info_canonicalized))
  end

  def assertion_variables
    assertion_params.merge(digest: @assertion_digest, signature: @signature_value)
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
end
