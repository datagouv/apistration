class APIEntreprise::V2::BilansINPIController < APIEntreprise::V2::DocumentsINPIController
  def show
    authorize :bilans_inpi

    process_through_authentication do
      retriever = SIADE::V2::Retrievers::BilansINPI.new(siren, cookie)
      retriever.retrieve

      if retriever.success?
        render json: APIEntreprise::INPI::BilansSerializer.new(retriever).as_json,
          status: retriever.http_code
      else
        render_errors(retriever)
      end
    end
  end
end
