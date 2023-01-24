module UseRetrievers
  extend ActiveSupport::Concern

  include Cacheable
  include OrganizersMethodsHelpers
end
