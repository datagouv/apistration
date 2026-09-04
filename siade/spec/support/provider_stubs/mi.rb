require_relative '../provider_stubs'

module ProviderStubs::MI
  def stub_mi_associations_valid_rna(rna: valid_rna_id)
    stub_mi_associations_structure(rna, status: 200, body: read_payload_file('mi/associations/valid_rna.json'))
  end

  def stub_mi_associations_valid_siret(siret: valid_siret(:rna))
    stub_mi_associations_structure(siret, status: 200, body: read_payload_file('mi/associations/valid_siret.json'))
  end

  def stub_mi_associations_rna_not_found(rna: non_existing_rna_id)
    stub_mi_associations_structure(rna, status: 404, body: read_payload_file('mi/associations/rna_not_found.json'))
  end

  def stub_mi_associations_documents_no_documents_key(id: '41763950700017')
    stub_mi_associations_structure(id, status: 200, body: read_payload_file('mi/associations/documents/no_documents_key.json'))
  end

  def stub_mi_associations_documents_with_documents(id: '77571979202585')
    stub_mi_associations_structure(id, status: 200, body: read_payload_file('mi/associations/documents/with_documents.json'))
  end

  private

  def stub_mi_associations_structure(id, status:, body:)
    stub_request(:get, "#{Siade.credentials[:mi_domain]}/apim/api-asso-partenaires/api/structure/#{id}")
      .with(query: { proxy_only: 'true' })
      .to_return(status:, body:)
  end
end
