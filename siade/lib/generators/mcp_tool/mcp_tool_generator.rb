class McpToolGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :param,
    type: 'string',
    desc: 'Param (siren/siret)',
    default: 'siren'

  class_option :description,
    type: 'string',
    desc: 'Description of the tool'

  def create_tool
    template 'tool.rb.erb', File.join('app/tools', "#{retriever.underscore}_tool.rb")
  end

  def create_test_tool
    template 'test_tool.rb.erb', File.join('spec/tools', "#{retriever.underscore}_tool_spec.rb")
  end

  def insert_authorization
    inject_into_file 'config/authorizations.yml', before: 'test:' do
      "    'mcp/#{retriever.underscore}': [valid_scope]\n"
    end
  end

  private

  def retriever
    name
  end

  def description
    options[:description]
  end

  def param
    options[:param]
  end

  def pattern
    case options[:param]
    when 'siren'
      '^\\d{9}$'
    when 'siret'
      '^\\d{14}$'
    else
      '.*'
    end
  end
end
