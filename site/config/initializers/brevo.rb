module BrevoSettings
  LIST_IDS = if Rails.env.staging? || Rails.env.sandbox?
               { 'entreprise' => 5, 'particulier' => 5 }
             else
               { 'entreprise' => 3, 'particulier' => 4 }
             end.freeze

  def self.list_id(api)
    LIST_IDS.fetch(api)
  end
end
