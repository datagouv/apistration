class CertificatRGEADEMESerializer < ActiveModel::Serializer
  attributes :domaines,
    :qualifications

  def domaines
    object.map(&:domaine)
  end

  def qualifications
    object.map { |certificat| qualification(certificat) }
  end

  def qualification(certificat)
    {
      nom: certificat.qualification[:nom],
      url_certificat: certificat.url,
      nom_certificat: certificat.nom_certificat
    }
  end
end
