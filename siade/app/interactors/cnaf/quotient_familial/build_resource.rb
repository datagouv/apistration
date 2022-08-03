class CNAF::QuotientFamilial::BuildResource < BuildResource
  def resource_attributes
    {
      adresse: build_address,
      allocataires: build_beneficaries,
      enfants: build_children,
      quotientFamilial: find_integer_or_nil('QUOTIENTF'),
      mois: find_integer_or_nil('DUMOIS'),
      annee: find_integer_or_nil('DELANNEE')
    }
  end

  private

  def build_address
    {
      identite: extract_address_part('LIBLIG1ADR'),
      complementIdentite: extract_address_part('LIBLIG2ADR'),
      complementIdentiteGeo: extract_address_part('LIBLIG3ADR'),
      numeroRue: extract_address_part('LIBLIG4ADR'),
      lieuDit: extract_address_part('LIBLIG5ADR'),
      codePostalVille: extract_address_part('LIBLIG6ADR'),
      pays: extract_address_part('LIBLIG7ADR')
    }.compact
  end

  def build_children
    build_persons_payload('identeEnfants UNENFANT')
  end

  def build_beneficaries
    build_persons_payload('identePersonnes UNEPERSONNE')
  end

  def build_persons_payload(css_identifier)
    data.css(css_identifier).dup.map do |node|
      build_person_payload(node)
    end
  end

  def build_person_payload(node)
    {
      nomPrenom: node.css('NOMPRENOM').text,
      dateDeNaissance: node.css('DATNAISS').text,
      sexe: node.css('SEXE').text
    }
  end

  def extract_address_part(key)
    data.css('adresse').css(key).text
  end

  def find_integer_or_nil(key)
    value = data.css(key).text

    return if value.blank?

    value.to_i
  end

  def data
    Nokogiri.XML(xml_without_mime.css('fluxRetour').children.text)
  end

  def xml_without_mime
    @xml_without_mime ||= Nokogiri.XML(response.body.split("\n")[4..].join("\n").strip)
  end
end
