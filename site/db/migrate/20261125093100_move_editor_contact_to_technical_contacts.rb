class MoveEditorContactToTechnicalContacts < ActiveRecord::Migration[8.1]
  def up = safety_assured { service.move_contacts_to_technical_contacts }
  def down = safety_assured { service.remove_technical_contacts }

  private

  def service
    EditorProfileBackfillService.new(executor: self)
  end
end
