class APIEntreprise::V3AndMore::MI::SIAF::AssociationsOpenDataController < APIEntreprise::V3AndMore::MI::SIAF::AssociationsController
  private

  def serializer_module
    ::APIEntreprise::MI::SIAF::AssociationsOpenDataSerializer
  end
end
