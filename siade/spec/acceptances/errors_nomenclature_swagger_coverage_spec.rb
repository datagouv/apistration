RSpec.describe 'Errors nomenclature swagger coverage', type: :acceptance do
  def swagger_statuses_by_operation_id(api)
    YAML.load_file(Rails.root.join("swagger/openapi-#{api}.yaml"), aliases: true)['paths'].each_value.with_object({}) do |path_schema, result|
      responses = path_schema.dig('get', 'responses') || {}
      operation_id = responses.dig('200', 'x-operationId')

      result[operation_id] = responses.keys.map(&:to_s) if operation_id
    end
  end

  %i[entreprise particulier].each do |api|
    it "documents in swagger/openapi-#{api}.yaml every error status the nomenclature lists for an operation" do
      swagger_statuses = swagger_statuses_by_operation_id(api)

      nomenclature = ErrorsNomenclature.new(api).to_h
      platform_statuses = nomenclature['platform_codes'].keys

      undocumented = nomenclature['endpoints'].each_with_object({}) do |(operation_id, endpoint), result|
        missing = (endpoint['errors'].keys | platform_statuses) - swagger_statuses.fetch(operation_id, [])

        result[operation_id] = missing if missing.any?
      end

      expect(undocumented).to be_empty, <<~MESSAGE
        The nomenclature served on the errors route lists these statuses, platform codes included, absent from the swagger:

        #{undocumented.map { |operation_id, statuses| "#{operation_id}: #{statuses.join(', ')}" }.join("\n")}

        Regenerate the swagger with bin/generate_swagger.sh: Openapi::ErrorsNomenclatureStatusFiller
        documents every status of the nomenclature an operation's request specs do not.
      MESSAGE
    end
  end
end
