class BackfillEditorUseCasesFromFormUids < ActiveRecord::Migration[8.1]
  def up = safety_assured { service.create_use_cases_from_form_uids }
  def down = safety_assured { service.remove_use_cases }

  private

  def service
    EditorProfileBackfillService.new(executor: self)
  end
end
