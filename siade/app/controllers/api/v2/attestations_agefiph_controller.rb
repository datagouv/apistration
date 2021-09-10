class API::V2::AttestationsAGEFIPHController < API::V2::BaseController
  def show
    authorize :attestations_agefiph

    attestation_retriever = SIADE::V2::Retrievers::AttestationsAGEFIPH.new(params[:siret])

    attestation_retriever.retrieve

    if attestation_retriever.success?
      render json: {
        derniere_annee_de_conformite_connue: attestation_retriever.derniere_annee_de_conformite_connue,
        dump_date: attestation_retriever.dump_date
      }, status: attestation_retriever.http_code
    else
      render_errors(attestation_retriever)
    end
  end
end
