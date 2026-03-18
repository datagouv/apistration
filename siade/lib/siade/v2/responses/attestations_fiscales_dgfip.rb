class SIADE::V2::Responses::AttestationsFiscalesDGFIP < SIADE::V2::Responses::AbstractDGFIPResponse
  def provider_name
    'DGFIP'
  end

  protected

  def adapt_raw_response_code
    if @raw_response.code.to_i != 200 || errors?
      if self.class.private_method_defined? "set_error_message_#{@raw_response.code}"
        set_error_message_for(@raw_response.code.to_i)
      else
        set_error_message_for_potential_not_found_error
      end
    else
      @raw_response.code.to_i
    end
  end

  private

  def errors?
    !!(@raw_response.body =~ /Page d'erreur|Rapport d'erreur/)
  end

  def set_error_message_404
    (@errors ||= []) << NotFoundError.new(provider_name, 'Le siret ou siren indiqué n\'existe pas, n\'est pas connu, n\'est pas en règle de ses obligations fiscales ou ne comporte aucune information pour cet appel.')
  end
end
