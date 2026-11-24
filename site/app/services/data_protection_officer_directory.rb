class DataProtectionOfficerDirectory
  DATASET_URL = 'https://www.data.gouv.fr/datasets/organismes-ayant-designe-un-e-delegue-e-a-la-protection-des-donnees-dpd-dpo'.freeze
  CACHE_DURATION = 1.day

  def self.find(siren)
    Rails.cache.fetch("data_protection_officer_directory/#{siren}", expires_in: CACHE_DURATION) do
      contact(CnilDataProtectionOfficersClient.new.latest_designation(siren))
    end
  rescue Faraday::Error
    {}
  end

  def self.contact(designation)
    return {} if designation.nil?

    {
      'delegue_protection_donnees_email' => designation['Moyen contact DPO email'],
      'delegue_protection_donnees_phone_number' => french_phone_number(designation['Moyen contact DPO téléphone'])
    }.compact_blank
  end

  def self.french_phone_number(number)
    number.to_s.match?(/\A[1-9]\d{8}\z/) ? "0#{number}" : number
  end
end
