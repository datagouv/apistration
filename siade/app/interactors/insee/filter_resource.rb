class INSEE::FilterResource < ApplicationInteractor
  class ResourceNotDefined < NotImplementedError; end

  def call
    filter_resource! if partially_diffusable?
  end

  protected

  def attributes_to_not_diffusible
    return general_attributes_to_not_diffusible if builded_resource.type == :personne_morale

    personne_physique_attributes_to_not_diffusible.deep_merge!(general_attributes_to_not_diffusible)
  end

  def partially_diffusable?
    builded_resource.status_diffusion == :partially_diffusable
  end

  def filter_resource!
    builded_resource.deep_merge!(attributes_to_not_diffusible)
  end

  def builded_resource
    context.bundled_data.data
  end

  def not_diffusible
    '[ND]'
  end
end
