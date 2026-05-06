module MailerUrlHelper
  def absolutize_links(html)
    return html if html.blank?

    options = ActionMailer::Base.default_url_options
    protocol = options[:protocol] || (Rails.env.production? ? 'https' : 'http')
    host = options[:host]
    return html if host.blank?

    html.gsub(%r{href="/([^"]*)"}, %(href="#{protocol}://#{host}/\\1")).html_safe
  end
end
