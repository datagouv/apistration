class INPIError < AbstractSpecificProviderError
  def provider_name
    'INPI'
  end

  def subcode_config
    {
      incorrect_ids:          '501',
      incorrect_brevets_json: '502',
      incorrect_modeles_json: '503',
      incorrect_marques_json: '504',
    }
  end
end
