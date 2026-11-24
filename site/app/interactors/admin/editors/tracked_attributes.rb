module Admin::Editors::TrackedAttributes
  UNTRACKED_COLUMNS = %w[id editor_id created_at updated_at].freeze

  def self.of(record)
    record.attributes.except(*UNTRACKED_COLUMNS)
  end
end
