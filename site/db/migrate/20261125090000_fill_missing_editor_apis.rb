class FillMissingEditorApis < ActiveRecord::Migration[8.1]
  def up = safety_assured { EditorProfileBackfillService.new(executor: self).fill_missing_apis }

  def down; end
end
