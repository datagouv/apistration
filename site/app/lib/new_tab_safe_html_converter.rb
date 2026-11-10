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

  def convert_table(element, indent)
    return super unless dsfr_table?(element)

    element.attr.delete('class')

    <<~HTML
      <div class="fr-table fr-table--bordered fr-table--multiline">
        <div class="fr-table__wrapper">
          <div class="fr-table__container">
            <div class="fr-table__content">
              #{super}
            </div>
          </div>
        </div>
      </div>
    HTML
  end

  private

  def dsfr_table?(element)
    element.attr['class'].to_s.split.include?('fr-table')
  end

  def protect_window_opener(element)
    element.attr['rel'] = 'noopener noreferrer' if element.attr['target'] == '_blank'
  end
end
