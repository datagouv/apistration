# rubocop:disable Metrics/ModuleLength
module INPI::RNE::ExtraitRNE::Concerns::DataFormatters
  include INPI::RNE::ExtraitRNE::Concerns::Constants

  DATE_FORMATTERS = {
    iso: lambda { |date|
      return nil if date.blank?

      if date.include?('T')
        DateTime.parse(date).strftime('%Y-%m-%d')
      else
        Date.parse(date).strftime('%Y-%m-%d')
      end
    },
    naissance: lambda { |date|
      return nil if date.blank?

      # Keep YYYY-MM format for partial dates (year-month only)
      date
    },
    cloture: lambda { |date|
      return nil if date.blank?

      if date =~ /^(\d{2})(\d{2})$/
        "#{::Regexp.last_match(2)}-#{::Regexp.last_match(1)}"
      elsif date =~ /^(\d{4})$/
        "#{date[0..1]}-#{date[2..3]}"
      else
        date
      end
    }
  }.freeze

  def format_date(date_string, type: :iso)
    return nil if date_string.blank?

    DATE_FORMATTERS[type].call(date_string)
  rescue StandardError
    date_string
  end

  def format_date_naissance(date_string)
    format_date(date_string, type: :naissance)
  end

  def format_date_cloture(date_string)
    format_date(date_string, type: :cloture)
  end

  def format_adresse(adresse, with_complement: false)
    return nil if adresse.blank?

    build_unified_address(adresse, with_complement)
  end

  def format_adresse_etablissement(adresse)
    format_adresse(adresse, with_complement: true)
  end

  def build_unified_address(adresse, with_complement)
    result = build_base_address_hash(adresse)
    add_complement_field(result, adresse, with_complement)
    result
  end

  def build_base_address_hash(adresse)
    parts = build_address_parts(adresse)
    {
      voie: parts.join(' ').upcase,
      code_postal: adresse['codePostal'],
      commune: adresse['commune']&.upcase,
      pays: adresse['pays'] || DEFAULT_PAYS
    }
  end

  def build_address_parts(adresse)
    [
      adresse['numVoie'],
      adresse['typeVoie'],
      adresse['voie']
    ].compact
  end

  def add_complement_field(result, adresse, _with_complement)
    result[:complement] = adresse['complementLocalisation']
  end

  def fix_encoding(text)
    return nil if text.nil?

    begin
      text.force_encoding(ENCODING_UTF8)

      return text.presence if text.valid_encoding?

      converted_text = text.force_encoding(ENCODING_ISO).encode(ENCODING_UTF8)
      converted_text.presence
    rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError
      text.force_encoding(ENCODING_UTF8).scrub
    end
  end

  def get_forme_juridique_libelle(code)
    FORME_JURIDIQUE_MAPPING[code] || "Forme juridique #{code}"
  end

  def get_activite_libelle(code_ape)
    get_code_from_config(:code_ape, code_ape, "Activité #{code_ape}")
  end

  def get_code_aprm_libelle(code_aprm)
    get_code_from_config(:code_aprm, code_aprm, "Activité Art #{code_aprm}")
  end

  def get_code_from_config(config_key, code, fallback)
    return fallback if code.blank?

    config_value = Rails.application.config_for(config_key)[code]
    config_value || fallback
  end

  def get_origine_fonds(activite)
    origine = safe_get(activite, 'origine')
    ORIGINE_FONDS_MAPPING[origine['typeOrigine']] || ORIGINE_FONDS_DEFAULT
  end

  def safe_get(hash, key, default = {})
    return default unless hash

    hash[key] || default
  end
end
# rubocop:enable Metrics/ModuleLength
