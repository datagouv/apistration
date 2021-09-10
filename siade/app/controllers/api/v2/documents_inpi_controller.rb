class API::V2::DocumentsINPIController < API::V2::BaseController
  def actes
    authorize :actes_inpi

    process_through_authentication do
      retriever = SIADE::V2::Retrievers::ActesINPI.new(siren, cookie)
      retriever.retrieve

      if retriever.success?
        render json: INPI::ActesSerializer.new(retriever).as_json,
          status: retriever.http_code
      else
        render_errors(retriever)
      end
    end
  end

  def bilans
    authorize :bilans_inpi

    process_through_authentication do
      retriever = SIADE::V2::Retrievers::BilansINPI.new(siren, cookie)
      retriever.retrieve

      if retriever.success?
        render json: INPI::BilansSerializer.new(retriever).as_json,
          status: retriever.http_code
      else
        render_errors(retriever)
      end
    end
  end

  private

  def siren
    params.require :siren
  end

  def cookie
    @cookie ||= SIADE::V2::Requests::INPI::Authenticate.new.cookie
  end

  def process_through_authentication
    if cookie.nil?
      error = ProviderAuthenticationError.new('INPI')

      render error_json(error, status: 502)
    else
      yield
    end
  end
end
