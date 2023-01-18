class APIEntreprise::V2::ActesINPIController < APIEntreprise::V2::DocumentsINPIController
  def show
    process_through_authentication do
      retriever = SIADE::V2::Retrievers::ActesINPI.new(siren, cookie)
      retriever.retrieve

      if retriever.success?
        render json: APIEntreprise::INPI::ActesSerializer.new(retriever).as_json,
          status: retriever.http_code
      else
        render_errors(retriever)
      end
    end
  end
end

