require 'csv'
require 'yaml'
require 'json'
require 'payloads_helpers'

class GenerateSummaryCSV
  include PayloadsHelpers

  attr_reader :operation_id

  def initialize(operation_id)
    @operation_id = operation_id
  end

  def perform
    CSV.open(csv_path, 'wb') do |csv|
      csv << headers

      payload_entries(operation_id).each do |payload_path|
        csv << generate_row(payload_path)
      end
    end
  end

  private

  def csv_path
    File.expand_path("payloads/#{operation_id}/summary.csv", root_path)
  end

  def headers
    [
      'Titre',
      'Description',
      'Paramètres',
      'Status',
      'Réponse'
    ]
  end

  def generate_row(payload_path)
    payload = YAML.load_file(payload_path)

    [
      payload['title'],
      payload['description'],
      payload['params'].to_json,
      payload['status'],
      payload['payload']
    ]
  end
end
