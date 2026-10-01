class MockedDatapassAPIClient
  def list_formulaires(definition_id)
    path = Rails.root.join("config/datapass_mocks/#{definition_id}_formulaires.yml")

    raise DatapassAPIClient::NotFound.new("No mocked formulaires for #{definition_id}", status: 404) unless path.exist?

    YAML.load_file(path)
  end
end
