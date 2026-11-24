class DatapassScope < ApplicationRecord
  validates :value, presence: true, uniqueness: { scope: :api }
  validates :api, inclusion: { in: Editor::APIS }

  scope :for_api, ->(api) { where(api:) }
  scope :current, -> { where(deprecated: false) }

  def label
    name.presence || value
  end
end
