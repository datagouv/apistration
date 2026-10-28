module MailerUrlHelper
  def absolutize_links(html)
    return html if html.blank? || mailer_base_url.nil?

    html.gsub(%r{href="/(?!/)([^"]*)"}, %(href="#{mailer_base_url}/\\1")).html_safe
  end

  def changelog_entry_as_text(markdown)
    return '' if markdown.blank?

    text = MarkdownInterpolator.new(markdown).content_interpolated
    return text if mailer_base_url.nil?

    text.gsub(%r{\]\(/(?!/)([^)]*)\)}, "](#{mailer_base_url}/\\1)")
  end

  private

  def mailer_base_url
    options = ActionMailer::Base.default_url_options
    return if options[:host].blank?

    protocol = options[:protocol] || (Rails.env.production? ? 'https' : 'http')
    "#{protocol}://#{options[:host]}"
  end
end
