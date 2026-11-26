module BrevoSettings
  IDS = if Rails.env.staging? || Rails.env.sandbox?
          {
            list: { 'entreprise' => 5, 'particulier' => 5 },
            newsletter_template: { 'entreprise' => 8, 'particulier' => 8 }
          }
        else
          {
            list: { 'entreprise' => 3, 'particulier' => 4 },
            newsletter_template: { 'entreprise' => 6, 'particulier' => 7 }
          }
        end.freeze

  def self.list_id(api)
    IDS[:list].fetch(api)
  end

  def self.newsletter_template_id(api)
    IDS[:newsletter_template].fetch(api)
  end
end
