module BrevoAPIMocks
  BREVO_CONTACTS_URL = 'https://api.brevo.com/v3/contacts'.freeze

  def stub_brevo_contacts_upsert(status: 201)
    stub_request(:post, BREVO_CONTACTS_URL).to_return(status:)
  end

  def brevo_contact_upsert(email:, attributes:, list_id:)
    a_request(:post, BREVO_CONTACTS_URL).with(
      headers: { 'api-key' => AdminApientreprise.credentials[:brevo_api_key] },
      body: {
        email:,
        attributes:,
        listIds: [list_id],
        updateEnabled: true
      }
    )
  end
end
