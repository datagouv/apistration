class Admin::EditorsController < AdminController
  before_action :set_editor, only: %i[show edit update]

  def index
    @editors = Editor.for_api(namespace).filtered(params).order(:name).page(params[:page])
    @users_counts = User.where(editor_id: @editors.map(&:id)).group(:editor_id).count
  end

  def show; end

  def new
    @editor = Editor.new
  end

  def edit; end

  def create
    @editor = Editor.new(editor_params)

    if @editor.save
      success_message(title: 'Éditeur créé')
      redirect_to admin_editor_path(@editor)
    else
      error_message(title: "Erreur lors de la création de l'éditeur")
      render 'new', status: :unprocessable_content
    end
  end

  def update
    result = Admin::Editors::Update.call(editor: @editor, editor_params:, admin: true_user, namespace:)

    if result.success?
      success_message(title: 'Éditeur mis à jour')
      redirect_to admin_editor_path(@editor)
    else
      error_message(title: "Erreur lors de la mise à jour de l'éditeur")
      render 'edit', status: :unprocessable_content
    end
  end

  private

  def set_editor
    @editor = Editor.find(params.expect(:id))
  end

  def editor_params
    params.expect(
      editor: [
        :name,
        :siret,
        :role,
        :contact_email,
        :contact_phone,
        :deployment_type,
        :setup_instructions,
        :domain,
        :languages,
        :description,
        :form_uids,
        :allowed_ips,
        :copy_token,
        :editor_tokens_enabled,
        { apis: [] }
      ]
    ).tap { |whitelisted| normalize_editor_params(whitelisted) }
  end

  def normalize_editor_params(whitelisted)
    whitelisted[:form_uids] = parse_comma_separated(whitelisted[:form_uids])
    whitelisted[:allowed_ips] = parse_comma_separated(whitelisted[:allowed_ips])
    whitelisted[:apis] = (whitelisted[:apis] || []).compact_blank
    whitelisted[:role] = nil if whitelisted[:role].blank?
    whitelisted[:deployment_type] = nil if whitelisted[:deployment_type].blank?
  end

  def parse_comma_separated(value)
    (value || '').split(/[,\n]/).map(&:strip).compact_blank
  end
end
