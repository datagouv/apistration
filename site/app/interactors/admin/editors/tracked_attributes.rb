module Admin::Editors::TrackedAttributes
  UNTRACKED_COLUMNS = %w[id created_at updated_at].freeze

  def self.of(editor)
    editor.attributes.except(*UNTRACKED_COLUMNS)
  end
end
