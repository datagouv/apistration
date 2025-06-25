class DGFIP::ADELIE::Ping::MakeRequest < DGFIP::ADELIE::MakeRequest
  def request_uri
    URI("#{base_url}/etatSante")
  end

  def request_params; end
end
