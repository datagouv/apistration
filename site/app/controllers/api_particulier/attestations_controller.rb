class APIParticulier::AttestationsController < ApplicationController
  layout 'api_particulier/attestation_verification'

  rate_limit to: 5, within: 1.minute, with: -> { head :too_many_requests }

  before_action :forbid_caching_and_indexing!

  def show
    @payload = APIParticulier::AttestationToken.read_verification(params[:token].to_s)
    @visual_code = APIParticulier::AttestationToken.visual_code(params[:token].to_s)
    @header_rows = build_header_rows
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    render :invalid, status: :not_found
  end

  private

  def forbid_caching_and_indexing!
    no_store
    response.headers['X-Robots-Tag'] = 'noindex'
  end

  def build_header_rows
    [
      ['SIRET du demandeur', @payload['siret']],
      ['Émise le', format_date(@payload['emise_le'])],
      ["Valable jusqu'au", format_date(@payload['valable_jusqu_au'])]
    ]
  end

  def format_date(value)
    Date.parse(value).strftime('%d/%m/%Y')
  end
end
