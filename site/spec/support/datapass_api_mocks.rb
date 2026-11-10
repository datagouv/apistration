module DatapassAPIMocks
  def datapass_formulaires_payload
    JSON.parse(Rails.root.join('spec/fixtures/datapass_api/formulaires.json').read)
  end

  def stub_datapass_formulaires(formulaires = datapass_formulaires_payload)
    allow(MockedDatapassAPIClient).to receive(:new).and_return(
      instance_double(MockedDatapassAPIClient, list_formulaires: formulaires)
    )
  end
end
