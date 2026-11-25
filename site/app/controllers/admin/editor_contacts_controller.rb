class Admin::EditorContactsController < AdminController
  before_action :set_editor

  def edit
    @contact = @editor.contacts.find(params.expect(:id))
  end

  def create
    result = Admin::EditorContacts::Create.call(editor: @editor, record_params: contact_params, admin: true_user, namespace:)
    flash_result(result, 'Contact ajouté')
  end

  def update
    result = Admin::EditorContacts::Update.call(editor: @editor, record_id: params.expect(:id), record_params: contact_params, admin: true_user, namespace:)
    @contact = result.record

    if result.success? || @contact.nil?
      flash_result(result, 'Contact mis à jour')
    else
      render 'edit', status: :unprocessable_content
    end
  end

  def destroy
    result = Admin::EditorContacts::Destroy.call(editor: @editor, record_id: params.expect(:id), admin: true_user, namespace:)
    flash_result(result, 'Contact retiré')
  end

  private

  def set_editor
    @editor = Editor.find(params.expect(:editor_id))
  end

  def contact_params
    params.expect(editor_contact: EditorContact::EDITABLE_ATTRIBUTES)
  end

  def flash_result(result, title)
    if result.success?
      success_message(title:)
    else
      error_message(title: result.message)
    end

    redirect_to admin_editor_path(@editor, onglet: 'contacts')
  end
end
