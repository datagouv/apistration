class DGFIP::Dictionaries::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      dictionnaire: json_body['dictionnaire']
    }
  end
end
