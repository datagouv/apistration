class INSEE::FilterPartiallyDiffusableResource < ApplicationInteractor
  class ResourceNotDefined < NotImplementedError; end

  def call
    filter_resource! if partiellement_diffusible?
  end

  protected

  def attributes_to_not_diffuse
    send("#{builded_resource.type}_attributes_to_not_diffuse")
  end

  def personne_physique_attributes_to_not_diffuse
    fail NotImplementedError
  end

  def personne_morale_attributes_to_not_diffuse
    fail NotImplementedError
  end

  def partiellement_diffusible?
    builded_resource.status_diffusion == :partiellement_diffusible
  end

  def filter_resource!
    builded_resource.deep_merge!(attributes_to_not_diffuse)
  end

  def builded_resource
    context.bundled_data.data
  end

  def not_diffusible
    '[ND]'
  end
end
