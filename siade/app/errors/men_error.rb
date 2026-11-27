class MENError < AbstractSpecificProviderError
  def provider_name
    'MEN'
  end

  def kind
    :not_found
  end

  protected

  def subcode_config
    {
      scolarite_not_found: '404',
      eleve_hors_perimetre: '405'
    }
  end
end
