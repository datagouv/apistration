class OPQIBI::CertificationsIngenierie::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      numero_certificat: json_body['numero_certificat'],
      url: json_body['url'],
      date_delivrance_certificat: normalized_date(json_body['date_de_delivrance_du_certificat']),
      duree_validite_certificat: json_body['duree_de_validite_du_certificat'],
      assurances: json_body['assurance'],
      qualifications: build_qualifications(json_body['qualifications']),
      date_validite_qualifications: normalized_date(json_body['date_de_validite_des_qualification']),
      qualifications_probatoires: build_qualifications(json_body['qualifications_probatoires']),
      date_validite_qualifications_probatoires: normalized_date(json_body['date_de_validite_des_qualifications_probatoires'])
    }
  end

  private

  def build_qualifications(qualifications)
    qualifications.map { |q| qualifications_attributes(q) }
  end

  def qualifications_attributes(qualification)
    {
      nom: qualification['Nom'],
      code_qualification: qualification['CodeQualification'],
      definition: qualification['Definition'],
      rge: cast_rge_to_boolean(qualification['rge'])
    }
  end

  def cast_rge_to_boolean(value)
    case value
    when '0'
      false
    when '1'
      true
    end
  end
end
