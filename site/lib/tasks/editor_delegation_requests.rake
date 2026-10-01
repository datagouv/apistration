require 'csv'

namespace :editor_delegation_requests do
  desc 'Import editor delegation requests from a CSV of SIRET and contact emails, and write their invitation links'
  task :import, %i[editor_use_case_id csv_path output_path] => :environment do |_, args|
    editor_use_case = EditorUseCase.find(args[:editor_use_case_id])
    output_path = args[:output_path] || args[:csv_path].sub(/(\.csv)?\z/, '-links.csv')

    result = EditorDelegationRequest::Import.call(
      editor_use_case:,
      rows: CSV.read(args[:csv_path], headers: true).map(&:to_h)
    )

    CSV.open(output_path, 'w') do |csv|
      csv << %w[siret contact_email url]

      result.editor_delegation_requests.each do |editor_delegation_request|
        csv << [
          editor_delegation_request.siret,
          editor_delegation_request.contact_email,
          "#{ProConnectConfig.host('entreprise')}#{editor_delegation_request.invitation_path}"
        ]
      end
    end

    puts "Created: #{result.created.size}"
    puts "Already imported: #{result.already_imported.size}"
    puts "Invalid SIRET (#{result.invalid_sirets.size}): #{result.invalid_sirets.join(', ')}"
    puts "Duplicates (#{result.duplicates.size}): #{result.duplicates.join(', ')}"
    puts "Failures (#{result.failures.size}): #{result.failures.map { |siret, message| "#{siret} (#{message})" }.join(', ')}"
    puts "Links: #{output_path}"
  end
end
