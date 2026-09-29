RSpec.shared_examples 'a CNAV response validator' do
  def not_found_response(payload, header = {})
    instance_double(Net::HTTPNotFound, code: 404, body: read_payload_file(payload), header:)
  end

  context 'when the SNGI does not identify the allocataire' do
    let(:response) { not_found_response('cnav/404-identity-not-found.json') }

    its('errors.first') { is_expected.to have_attributes(class: ProviderUnprocessableEntityError, reason: :unidentified_person) }
  end

  context 'when no eligible caisse knows the allocataire' do
    let(:response) { not_found_response('cnav/404-regime-not-found.json') }

    its('errors.first') { is_expected.to have_attributes(class: NotFoundError, provider_name: 'CNAF & MSA') }
  end

  {
    'CNAF' => '00810011',
    'MSA' => '00171001',
    'RNCPS' => '99430000'
  }.each do |regime, code_organisme|
    context "when the #{regime} has no file for the allocataire" do
      let(:response) { not_found_response('cnav/complementaire_sante_solidaire/404.json', 'X-APISECU-FD' => code_organisme) }

      its('errors.first') { is_expected.to have_attributes(class: NotFoundError, provider_name: regime) }
    end
  end

  context 'when the caisse rejects the civility' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: 400, body: '{"errorCode":40013,"error":"Format de la commune de naissance erroné"}', header: {}) }

    its('errors.first') { is_expected.to have_attributes(class: ProviderUnprocessableEntityError, reason: :rejected_civility) }
  end
end
