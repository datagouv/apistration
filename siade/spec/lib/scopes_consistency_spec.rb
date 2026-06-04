require 'rails_helper'

RSpec.describe 'API Particulier scopes consistency' do # rubocop:disable RSpec/DescribeClass
  let(:authorizations) do
    YAML.safe_load_file(Rails.root.join('config/authorizations.yml'), aliases: true).fetch('shared')
  end
  let(:master_scopes) { authorizations.values.flatten.uniq }
  let(:api_particulier_scopes) do
    authorizations.select { |controller, _| controller.start_with?('api_particulier/') }.values.flatten.uniq
  end

  def collect_scopes(node)
    case node
    in Hash
      node.flat_map { |key, value| key == 'scope' ? Array(value).map(&:to_s) : collect_scopes(value) }
    in Array
      node.flat_map { |item| collect_scopes(item) }
    else
      []
    end
  end

  def format_violations(violations)
    violations.map { |source, scopes| "  #{source}: #{scopes.inspect}" }.join("\n")
  end

  it 'every fiche only declares scopes authorized for its controller' do
    violations = Rails.root.glob('config/endpoints/api_particulier/*.yml').filter_map do |path|
      fiche = YAML.safe_load_file(path, aliases: true).fetch('fiche').first
      unauthorized = collect_scopes(fiche['swagger']).uniq - Array(authorizations[fiche['controller']])
      [File.basename(path), unauthorized] if unauthorized.any?
    end

    expect(violations).to be_empty,
      "Fiches declaring scopes not granted to their controller in commons/data/authorizations.yml:\n#{format_violations(violations)}"
  end

  it 'every shared swagger file only declares known scopes' do
    violations = Rails.root.glob('config/swagger_data/*.yml').filter_map do |path|
      shared = YAML.safe_load_file(path, aliases: true, permitted_classes: [Date])
      unknown = collect_scopes(shared).uniq - master_scopes
      [File.basename(path), unknown] if unknown.any?
    end

    expect(violations).to be_empty,
      "Shared swagger files mentioning scopes absent from commons/data/authorizations.yml:\n#{format_violations(violations)}"
  end

  it 'every API Particulier serializer only references known scopes' do
    scope_call = /scope\?\(\s*:([a-z_][a-z0-9_]*)/
    one_of_scopes = /one_of_scopes\?\(\s*%i\[([^\]]+)\]/

    violations = Rails.root.glob('app/serializers/api_particulier/**/*.rb').filter_map do |path|
      content = File.read(path)
      referenced = content.scan(scope_call).flatten + content.scan(one_of_scopes).flat_map { |match| match.first.split }
      unknown = referenced.uniq - master_scopes
      [Pathname.new(path).relative_path_from(Rails.root).to_s, unknown] if unknown.any?
    end

    expect(violations).to be_empty,
      "Serializers calling scope?(:foo) on scopes absent from commons/data/authorizations.yml:\n#{format_violations(violations)}"
  end

  it 'API Particulier scope index contains only non-empty strings' do
    expect(api_particulier_scopes).to all(satisfy { |s| [*s] == [s] && s.length.positive? })
  end
end
