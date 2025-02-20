class DGFIP::LiensCapitalistiques::ValidateResponse < DGFIP::LiassesFiscales::ValidateResponse
  def call
    super

    return if contains_liens_capitalistiques_cerfas?

    make_payload_cacheable!

    resource_not_found!
  end

  private

  def contains_liens_capitalistiques_cerfas?
    %w[2059F 2059G].intersect?(numero_imprimes)
  end

  def numero_imprimes
    json_body['declarations'].pluck('numero_imprime')
  end
end
