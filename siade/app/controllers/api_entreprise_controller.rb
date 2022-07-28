class APIEntrepriseController < APIController
  include HasMandatoryParams
  include MockableInStaging
end
