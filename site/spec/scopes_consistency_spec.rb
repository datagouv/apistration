require 'rails_helper'

RSpec.describe 'API Particulier scopes consistency' do # rubocop:disable RSpec/DescribeClass
  it 'every API Particulier scope has an i18n label' do
    authorizations = YAML.safe_load_file(Rails.root.join('config/route_scopes.yml'), aliases: true).fetch('shared')
    scopes = authorizations.select { |controller, _| controller.start_with?('api_particulier/') }.values.flatten.uniq.sort

    missing = scopes.reject { |scope| I18n.exists?("api_particulier.tokens.token.scope.#{scope}.label", :fr) }

    expect(missing).to be_empty,
      "Missing fr i18n labels for scopes:\n#{missing.map { |s| "  #{s}" }.join("\n")}\n" \
      'Add them under api_particulier.tokens.token.scope.<name>.label.'
  end
end
