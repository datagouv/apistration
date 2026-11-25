# frozen_string_literal: true

RSpec.shared_examples 'a newsletter subscription feature' do |list_id:, template_id:|
  let(:email) { 'abonne@commune.fr' }

  before do
    Rails.application.config.rate_limit_store.clear
    stub_brevo_double_optin
  end

  def subscribe(email, honeypot: nil)
    visit newsletter_path
    fill_in I18n.t('shared.newsletter_subscriptions.form.email_label'), with: email
    fill_in I18n.t('shared.newsletter_subscriptions.form.honeypot_label'), with: honeypot if honeypot
    click_button I18n.t('shared.newsletter_subscriptions.form.submit')
  end

  it 'asks Brevo to send the double opt-in e-mail for the list of the API, then confirms the request' do
    subscribe(email)

    expect(
      brevo_double_optin(email:, list_id:, template_id:, redirection_url: "http://#{SiteHost.for(RSpec.current_example.metadata[:app].to_s)}/infolettre/confirmation")
    ).to have_been_made.once
    expect(page).to have_current_path(newsletter_path)
    expect(page).to have_text(I18n.t('shared.newsletter_subscriptions.create.success.title'))
  end

  it 'welcomes back on the newsletter page the visitor who clicked the confirmation link' do
    visit newsletter_confirmed_path

    expect(page).to have_current_path(newsletter_path)
    expect(page).to have_text(I18n.t('shared.newsletter_subscriptions.confirmed.title'))
  end

  it 'shows the same confirmation to a bot filling the hidden field, without calling Brevo' do
    subscribe(email, honeypot: 'spam')

    expect(a_request(:post, BrevoAPIMocks::BREVO_DOUBLE_OPTIN_URL)).not_to have_been_made
    expect(page).to have_text(I18n.t('shared.newsletter_subscriptions.create.success.title'))
  end

  it 'accepts three subscriptions from the same IP within a minute, then refuses the fourth' do
    %w[un deux trois quatre].each { |n| subscribe("#{n}@commune.fr") }

    expect(a_request(:post, BrevoAPIMocks::BREVO_DOUBLE_OPTIN_URL)).to have_been_made.times(3)
    expect(page).to have_text(I18n.t('shared.newsletter_subscriptions.create.error.too_many_requests'))
  end

  it 'rejects an invalid address without calling Brevo' do
    subscribe('pas-une-adresse')

    expect(a_request(:post, BrevoAPIMocks::BREVO_DOUBLE_OPTIN_URL)).not_to have_been_made
    expect(page).to have_text(I18n.t('shared.newsletter_subscriptions.create.error.invalid_email'))
  end

  it 'answers a bad request (ParameterMissing), without calling Brevo, to a form posted with a malformed payload' do
    expect { page.driver.post newsletter_subscribe_path, newsletter_subscription: 'spam' }.to raise_error(ActionController::ParameterMissing)
    expect(a_request(:post, BrevoAPIMocks::BREVO_DOUBLE_OPTIN_URL)).not_to have_been_made
  end

  it 'tells the visitor to retry later when Brevo fails' do
    stub_brevo_double_optin(status: 500)

    subscribe(email)

    expect(page).to have_text(I18n.t('shared.newsletter_subscriptions.create.error.brevo_error'))
  end
end
