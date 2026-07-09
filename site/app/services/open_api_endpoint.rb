class OpenAPIEndpoint
  attr_reader :path, :open_api_definition, :api

  def initialize(path:, open_api_definition:, api:)
    @path = path
    @open_api_definition = open_api_definition
    @api = api
  end

  def uid = path

  def version
    path[%r{\A/(v\d+)/}, 1]
  end

  def title
    summary = open_api_definition['summary']
    return path if summary.blank?

    format_title(summary)
  end

  def title_with_version
    return title if version.blank?

    "#{title} (#{version})"
  end

  private

  def format_title(summary)
    match = summary.match(/\[(.+?)\]/)
    return summary.strip unless match

    "#{summary.gsub(/\[.*?\]/, '').strip} (#{match[1]})"
  end
end
