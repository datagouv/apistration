module DatapassAPIMocks
  def datapass_formulaires_payload
    JSON.parse(Rails.root.join('spec/fixtures/datapass_api/formulaires.json').read)
  end

  def stub_datapass_formulaires(formulaires = datapass_formulaires_payload)
    demande_ids = (1001..).each

    instance_double(DatapassAPIClient, list_formulaires: formulaires, update_demande: {}, submit_demande: {}).tap do |client|
      allow(client).to receive(:create_demande) { { 'id' => demande_ids.next } }
      allow(DatapassAPIClient).to receive(:new).and_return(client)
    end
  end
end
