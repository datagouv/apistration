class ApplicationRecord < ActiveRecord::Base
  default_scope -> { order(created_at: :asc) }

  self.abstract_class = true

  def readonly?
    true
  end
end
