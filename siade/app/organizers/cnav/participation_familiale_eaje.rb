class CNAV::ParticipationFamilialeEAJE < CNAV::RetrieverOrganizer
  class MockedInteractor < ::MockedInteractor
    def mocking_params
      mocking_params = super.compact
      mocking_params.delete(:request_id)
      mocking_params.deep_transform_keys! do |key|
        key.to_s.camelize(:lower).gsub('INSEE', 'Insee')
      end

      mocking_params
    end
  end

  organize CNAV::ValidateParams,
    CNAV::ParticipationFamilialeEAJE::MockedInteractor

  def provider_name
    'Sécurité sociale'
  end

  def dss_prestation_name
    'participation_familiale_eaje'
  end
end
