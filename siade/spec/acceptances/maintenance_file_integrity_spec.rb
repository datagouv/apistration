RSpec.describe 'Maintenance test file integrity', type: :acceptance do
  let(:maintenance_file_data) do
    YAML.load_file(Rails.root.join('config/maintenances.yml'), aliases: true)
  end

  def test_date(provider, date)
    Date.parse(date)
  rescue Date::Error
    fail "Provider #{provider} has an invalid date: #{date}"
  end

  def test_hour(provider, hour)
    Time.zone.parse(hour) || raise
  rescue StandardError
    fail "Provider #{provider} has an invalid hour: #{hour}"
  end

  def test_hours(provider, data)
    test_hour(provider, data['from_hour'])
    test_hour(provider, data['to_hour'])
  end

  # rubocop:disable RSpec/NoExpectationExample
  it 'is valid' do
    maintenance_file_data['production'].each do |provider, data|
      fail "Provider '#{provider}' doesn't exist" if ErrorsBackend.instance.provider_code_from_name(provider).nil?

      if data.key?('dates')
        data['dates'].each do |date_data|
          test_date(provider, date_data['day'])
          test_hours(provider, date_data)
        end
      else
        test_hours(provider, data)
      end
    end
  end
  # rubocop:enable RSpec/NoExpectationExample
end
