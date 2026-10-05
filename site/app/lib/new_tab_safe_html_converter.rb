require 'kramdown'

class NewTabSafeHtmlConverter < Kramdown::Converter::Html
  def convert_a(element, indent)
    protect_window_opener(element)
    super
  end

  def convert_html_element(element, indent)
    protect_window_opener(element) if element.value == 'a'
    super
  end

  private

  def protect_window_opener(element)
    element.attr['rel'] = 'noopener noreferrer' if element.attr['target'] == '_blank'
  end
end
