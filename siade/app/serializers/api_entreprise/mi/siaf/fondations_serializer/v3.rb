class APIEntreprise::MI::SIAF::FondationsSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :identifiants,
    :identite,
    :activites,
    :filiation,
    :dirigeants

  attribute :beneficiaires_effectifs, if: -> { scope?(:fondations_mi_siaf_beneficiaires_effectifs) }

  attribute :situation_financiere do
    if scope?(:fondations_mi_siaf_controle)
      data.situation_financiere
    else
      data.situation_financiere.slice(:annees_subventions_publiques)
    end
  end

  attribute :documents do
    data.documents
      .select { |document| scope?(document[:scope]) }
      .map { |document| document.except(:scope).merge(url: download_url(document)) }
  end

  private

  def download_url(document)
    url_for(
      controller: 'api_entreprise/siaf_fondations_proxy',
      action: :show,
      uuid: StringEncryptorService.instance.encrypt_url_safe(download_link_payload(document).to_json)
    )
  end

  def download_link_payload(document)
    {
      rnf: data.identifiants[:rnf],
      file_id: document[:id],
      mime_type: document[:type_mime],
      scope: document[:scope],
      timestamp: Time.zone.now.to_i,
      token_id: current_user.token_id,
      token_type: current_user.editor? ? 'editor' : 'classic',
      authorization_request_id: current_user.authorization_request_id
    }
  end
end
