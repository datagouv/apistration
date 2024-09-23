class APIParticulier::V3AndMore::BaseSerializer < BaseSerializer
  def serialize_single_resource
    snakify(serialize_model(data))
  end

  private

  def snakify(hash)
    hash.deep_transform_keys { |key| key.to_s.underscore.to_sym }
  end
end
