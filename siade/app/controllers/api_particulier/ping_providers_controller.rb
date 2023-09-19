# frozen_string_literal: true

class APIParticulier::PingProvidersController < ApplicationController
  include Cacheable

  def show
    if provider_exists?
      if retrieve_payload_data(retriever).success?
        render status: :ok
      else
        render status: :bad_gateway
      end
    else
      render status: :not_found
    end
  end

  private

  def provider_exists?
    providers_to_organizer_and_params.key?(params[:provider])
  end

  def retriever
    providers_to_organizer_and_params[params[:provider]][:retriever]
  end

  def organizer_params
    providers_to_organizer_and_params[params[:provider]][:params]
  end

  def operation_id
    "ping_#{params[:provider]}"
  end

  # rubocop:disable Metrics/MethodLength
  def providers_to_organizer_and_params
    {
      'caf' => {
        retriever: ::CNAF::QuotientFamilial,
        params: {
          beneficiary_number: Siade.credentials[:ping_cnaf_numero_allocataire],
          postal_code: Siade.credentials[:ping_cnaf_postal_code]
        }
      },
      'impots' => {
        retriever: ::DGFIP::SituationIR,
        params: {
          tax_number: Siade.credentials[:ping_dgfip_svair_numero_fiscal],
          tax_notice_number: Siade.credentials[:ping_dgfip_svair_reference_avis]
        }
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
