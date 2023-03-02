RSpec.describe 'Requests debugging test file integrity', type: :acceptance do
  let(:requests_debugging_data) do
    YAML.load_file(Rails.root.join('config/requests_debugging.yml'), aliases: true)
  end

  def test_date(date)
    Date.parse(date)
  rescue Date::Error
    fail "Invalid date: #{date}"
  end

  def test_hours(provider, data)
    test_hour(provider, data['from_hour'])
    test_hour(provider, data['to_hour'])
  end

  it 'is valid' do
    %w[
      production
      staging
      sandbox
    ].each do |env|
      data = requests_debugging_data[env]

      expect(data['enable_until']).to be_present
      test_date(data['enable_until'])

      expect(data['operation_ids']).to be_instance_of(Array)
    end
  end
end
