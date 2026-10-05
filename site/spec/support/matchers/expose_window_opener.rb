RSpec::Matchers.define :expose_window_opener do
  unprotected_new_tab_links = 'a[target="_blank"]:not([rel~="noopener"])'

  match { |page| page.has_css?(unprotected_new_tab_links) }
  match_when_negated { |page| page.has_no_css?(unprotected_new_tab_links) }

  failure_message_when_negated do |page|
    hrefs = page.all(unprotected_new_tab_links).pluck(:href)

    "expected no new tab link without rel=\"noopener\", found: #{hrefs.join(', ')}"
  end
end
