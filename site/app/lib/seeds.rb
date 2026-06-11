class Seeds
  def perform
    @user = create_main_user
    @contact = create_contact

    create_editor
    create_provider_user
    create_api_entreprise_admin
    create_api_particulier_admin
    create_data_for_api_entreprise
    create_data_for_api_particulier
    create_data_shared
    create_editor_delegations
    create_editor_token
    create_audit_notifications
    create_provider_dashboard_data
    create_admin_activities
  end

  def flushdb
    raise 'Not in production!' if Rails.env.production?

    load_all_models!

    ProlongTokenWizard.destroy_all

    ActiveRecord::Base.connection.transaction do
      MagicLink.delete_all
      views = ActiveRecord::Base.connection.views
      ApplicationRecord.descendants.reject { |k| views.include?(k.table_name) }.each(&:delete_all)
      AccessLog.delete_all
    end
  end

  def create_scopes(api)
    namespace = "api_#{api}/"
    RouteScopesStore.instance.index
      .select { |controller, _| controller.start_with?(namespace) }
      .values.flatten.uniq
  end

  private

  def create_data_for_api_entreprise
    @scopes_entreprise = create_scopes('entreprise')

    token = create_api_entreprise_token_valid

    another_token = token.dup
    another_token.save!

    create_api_entreprise_token_blacklisted
    create_api_entreprise_token_expired
    create_api_entreprise_authorization_refused
  end

  def create_data_for_api_particulier
    @scopes_particulier = create_scopes('particulier')

    create_api_particulier_token_valid
  end

  def create_data_shared
    create_magic_link
  end

  def create_main_user
    create_user(
      email: 'user@yopmail.com',
      first_name: 'Jean',
      last_name: 'Dupont'
    )
  end

  def create_contact
    create_user(
      email: 'contact_technique@yopmail.com',
      first_name: 'Justine',
      last_name: 'Martin'
    )
  end

  def create_editor
    @editor = Editor.create!(
      name: 'MGDIS',
      form_uids: %w[api-entreprise-mgdis],
      copy_token: true,
      delegations_enabled: true,
      siret: '32816124500027',
      role: 'manages_token',
      contact_email: 'contact-mgdis@yopmail.com',
      contact_phone: '0299000000',
      deployment_type: 'saas',
      domain: 'mgdis.fr',
      languages: 'Java',
      description: 'Éditeur de solutions de gestion financière pour le secteur public',
      allowed_ips: ['192.0.2.10', '192.0.2.11', '198.51.100.5'],
      setup_instructions: "1. Se connecter au portail MGDIS\n2. Administration > Connecteurs API\n3. Renseigner le jeton API Entreprise"
    )
    create_user(
      email: 'editeur@yopmail.com',
      first_name: 'Edouard',
      last_name: 'Lefevre',
      editor: @editor
    )
    create_user(
      email: 'dev-mgdis@yopmail.com',
      first_name: 'Sophie',
      last_name: 'Durand',
      editor: @editor
    )

    Editor.create!(
      name: 'Atexo',
      form_uids: %w[api-entreprise-atexo],
      siret: '44090956200033',
      role: 'manages_token',
      contact_email: 'contact-atexo@yopmail.com',
      deployment_type: 'saas',
      domain: 'atexo.com',
      languages: 'Java, JavaScript',
      description: 'Éditeur de solutions de dématérialisation des marchés publics',
      allowed_ips: ['203.0.113.20', '203.0.113.21']
    )

    Editor.create!(
      name: 'Aiga',
      form_uids: %w[api-particulier-aiga api-particulier-aiga-petite-enfance],
      siret: '39825361700045',
      role: 'client_manages_token',
      deployment_type: 'on_premise',
      domain: 'aiga.fr',
      description: 'Éditeur de logiciels pour la petite enfance et les services périscolaires'
    )
  end

  def create_provider_user
    create_user(
      email: 'user10@yopmail.com',
      first_name: 'Michel',
      last_name: 'Paul',
      provider_uids: %w[insee dgfip]
    )
  end

  def create_api_entreprise_admin
    create_user(
      email: 'api-entreprise@yopmail.com',
      first_name: 'Admin',
      last_name: 'API Entreprise'
    )
  end

  def create_api_particulier_admin
    create_user(
      email: 'api-particulier@yopmail.com',
      first_name: 'Admin',
      last_name: 'API Particulier'
    )
  end

  def create_editor_delegations
    ar = AuthorizationRequest.find_by(demarche: 'api-entreprise-mgdis')
    EditorDelegation.create!(editor: @editor, authorization_request: ar) if ar
  end

  def create_editor_token
    EditorToken.create!(
      id: '00000000-0000-0000-0000-000000000001',
      editor: @editor,
      iat: Time.zone.now.to_i,
      exp: 18.months.from_now.to_i
    )
  end

  def create_magic_link
    MagicLink.create!(email: @user.email)
  end

  def create_api_entreprise_token_valid
    create_token(
      %w[open_data unites_legales_etablissements_insee attestation_sociale_urssaf attestation_fiscale_dgfip],
      'entreprise',
      token_params: { id: '00000000-0000-0000-0000-000000000000' },
      demandeur: @user,
      contact_technique: @contact,
      authorization_request_params: {
        intitule: 'Mairie de Lyon 2',
        external_id: 102,
        status: :validated,
        validated_at: 2.weeks.ago,
        first_submitted_at: 2.weeks.ago,
        demarche: 'api-entreprise-mgdis',
        siret: '12000101100010'
      }
    )
  end

  def create_api_entreprise_token_archived
    create_token(
      @scopes_entreprise.sample(2),
      'entreprise',
      token_params: { archived: true },
      demandeur: @user,
      contact_technique: @contact,
      authorization_request_params: {
        intitule: 'Mairie de Strasbourg',
        external_id: 103,
        status: :validated,
        validated_at: 1.week.ago,
        first_submitted_at: 1.week.ago,
        siret: '21670482500019'
      }
    )
  end

  def create_api_entreprise_token_blacklisted
    create_token(
      @scopes_entreprise.sample(2),
      'entreprise',
      token_params: { blacklisted_at: 6.months.ago, exp: 14.months.ago },
      demandeur: @user,
      authorization_request_params: {
        intitule: 'Mairie de Paris',
        external_id: 104,
        status: :validated,
        validated_at: 1.week.ago,
        first_submitted_at: 1.week.ago,
        siret: '21750001600019'
      }
    )
  end

  def create_api_entreprise_token_expired
    create_token(
      @scopes_entreprise.sample(2),
      'entreprise',
      token_params: { exp: 1.year.ago, created_at: 2.years.ago + 1.week },
      demandeur: @user,
      authorization_request_params: {
        intitule: 'Mairie de Montpellier',
        external_id: 105,
        status: :validated,
        api: 'entreprise',
        first_submitted_at: 2.years.ago,
        validated_at: 2.years.ago + 1.week,
        siret: '21340172201787'
      }
    )
  end

  def create_api_entreprise_authorization_refused
    create_user_authorization_request_role(
      user: @user,
      authorization_request: create_authorization_request(
        api: 'entreprise',
        intitule: 'Mairie de Bruges',
        status: :refused,
        external_id: 106,
        first_submitted_at: 2.years.ago,
        validated_at: 2.years.ago + 1.week,
        siret: '21330075900015'
      ),
      role: 'demandeur'
    )
  end

  def create_api_particulier_token_valid
    create_token(
      @scopes_particulier,
      'particulier',
      demandeur: @user,
      contact_metier: @contact,
      contact_technique: @contact,
      authorization_request_params: {
        intitule: 'Mairie de Bordeaux',
        external_id: 201,
        status: :validated,
        validated_at: 2.weeks.ago,
        demarche: 'api-particulier-aiga',
        first_submitted_at: 2.weeks.ago
      }
    )
  end

  def create_user(params = {})
    User.create!(params)
  end

  # rubocop:disable Metrics/ParameterLists
  def create_token(scopes, api, demandeur:, contact_technique: nil, contact_metier: nil, token_params: {}, authorization_request_params: {})
    authorization_request = create_authorization_request(authorization_request_params.merge(api:))

    create_user_authorization_request_role(user: demandeur, authorization_request:, role: 'demandeur')
    create_user_authorization_request_role(user: contact_technique, authorization_request:, role: 'contact_technique') if contact_technique
    create_user_authorization_request_role(user: contact_metier, authorization_request:, role: 'contact_metier') if contact_metier

    token = Token.create!(
      Token.default_create_params
        .merge(token_params)
        .merge(scopes:)
        .merge(
          authorization_request:
        )
    )

    authorization_request.update!(scopes:)

    create_access_logs_for_token(token) unless AccessLog.new.readonly?

    token
  end
  # rubocop:enable Metrics/ParameterLists

  def create_access_logs_for_token(token)
    [
      Time.zone.now,
      3.hours.ago,
      1.day.ago,
      2.days.ago,
      3.days.ago,
      8.days.ago
    ].each do |timestamp|
      AccessLog.create!(
        path: '/api/v3/what/ever',
        request_id: SecureRandom.uuid,
        token:,
        timestamp:
      )
    end
  end

  def create_authorization_request(params = {})
    find_or_create_organization(params[:siret]) if params[:siret]
    AuthorizationRequest.create!(params)
  end

  def find_or_create_organization(siret)
    organization = Organization.find_by(siret:)

    return organization if organization

    Organization.create!(
      siret:,
      insee_payload: JSON.parse(Rails.root.join("spec/fixtures/insee/#{siret}.json").read)
    )
  end

  def create_user_authorization_request_role(params = {})
    UserAuthorizationRequestRole.create!(params)
  end

  # rubocop:disable Metrics/AbcSize
  def create_audit_notifications
    authorization_requests = AuthorizationRequest.where.not(siret: nil).includes(:tokens).limit(3)

    authorization_requests.each_with_index do |auth_request, index|
      next unless auth_request.tokens.any?

      access_logs = AccessLog.joins(:token)
        .where(tokens: { authorization_request: auth_request })
        .limit(2 + index)

      next if access_logs.empty?

      AuditNotification.create!(
        authorization_request_external_id: auth_request.external_id,
        request_id_access_logs: access_logs.pluck(:request_id),
        contact_emails: [auth_request.demandeur&.email, auth_request.contact_technique&.email].compact.uniq,
        approximate_volume: 9001 + index,
        reason: [
          'Contrôle de routine - vérification des logs d\'accès',
          'Audit sécurité - activité suspecte détectée',
          'Investigation - paramètres incorrects dans les requêtes'
        ][index % 3]
      )
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def create_admin_activities
    admin = User.find_by(email: 'api-entreprise@yopmail.com')
    particulier_admin = User.find_by(email: 'api-particulier@yopmail.com')
    token = Token.first
    editor_token = EditorToken.first
    audit = AuditNotification.first

    AdminActivity.create!([
      { name: 'impersonation_started', admin:, namespace: 'entreprise', entity: @user, created_at: 2.days.ago },
      { name: 'impersonation_stopped', admin:, namespace: 'entreprise', entity: @user, created_at: 2.days.ago + 7.minutes },
      { name: 'user_updated', admin:, namespace: 'entreprise', entity: @user,
        before_attributes: { 'provider_uids' => [] }, after_attributes: { 'provider_uids' => %w[insee] }, created_at: 30.hours.ago },
      { name: 'editor_updated', admin:, namespace: 'entreprise', entity: @editor,
        before_attributes: { 'delegations_enabled' => false }, after_attributes: { 'delegations_enabled' => true }, created_at: 26.hours.ago },
      { name: 'token_banned', admin:, namespace: 'entreprise', entity: token,
        before_attributes: { 'blacklisted_at' => nil },
        after_attributes: { 'blacklisted_at' => 1.month.from_now, 'comment' => 'Jeton compromis', 'generate_new_token' => true, 'new_token_id' => Token.where.not(id: token&.id).first&.id }, created_at: 20.hours.ago },
      { name: 'token_created', admin:, namespace: 'entreprise', entity: token,
        after_attributes: { 'exp' => token&.exp, 'scopes' => token&.scopes }, created_at: 18.hours.ago },
      { name: 'editor_token_created', admin:, namespace: 'entreprise', entity: editor_token,
        after_attributes: { 'exp' => editor_token&.exp }, created_at: 12.hours.ago },
      { name: 'audit_notification_created', admin: particulier_admin, namespace: 'particulier', entity: audit,
        after_attributes: audit&.slice('authorization_request_external_id', 'reason', 'approximate_volume') || {}, created_at: 3.hours.ago }
    ])
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Lint/UselessConstantScoping
  INSEE_ENDPOINTS = %w[
    api_entreprise/v3_and_more/insee/etablissements
    api_entreprise/v3_and_more/insee/unites_legales
    api_entreprise/v3_and_more/insee/successions
  ].freeze

  INSEE_SCOPES = %w[unites_legales_etablissements_insee open_data_unites_legales_etablissements_insee].freeze

  INSEE_CONSUMERS = [
    { external_id: '50001', intitule: 'Mairie de Bruges', siret: '21330075900015', email: 'demandeur1@yopmail.com', validated_days_ago: 70 },
    { external_id: '50002', intitule: 'Mairie de Paris', siret: '21750001600019', email: 'demandeur2@yopmail.com', validated_days_ago: 35 },
    { external_id: '50003', intitule: 'Mairie de Montpellier', siret: '21340172201787', email: 'demandeur3@yopmail.com', validated_days_ago: 5 }
  ].freeze

  INSEE_PENDING_HABILITATIONS = [
    { external_id: '50100', intitule: "Conseil départemental de l'Hérault", siret: '12000101100010', status: :submitted, submitted_days_ago: 2 },
    { external_id: '50101', intitule: 'Région Occitanie', siret: '13002526500013', status: :changes_requested, submitted_days_ago: 20 },
    { external_id: '50102', intitule: 'Ville de Toulouse', siret: '21310555400017', status: :refused, submitted_days_ago: 50, validated_days_ago: nil },
    { external_id: '50103', intitule: 'Métropole de Lille', siret: '21590350200014', status: :revoked, submitted_days_ago: 80, validated_days_ago: 75 }
  ].freeze
  # rubocop:enable Lint/UselessConstantScoping

  def create_provider_dashboard_data
    return if AccessLog.new.readonly?

    INSEE_CONSUMERS.each do |attrs|
      token = create_insee_consumer(attrs)
      seed_access_logs_for(token, attrs[:validated_days_ago])
    end
    create_pending_insee_habilitations
  end

  def create_insee_consumer(attrs)
    user = User.find_by(email: attrs[:email]) || create_user(
      email: attrs[:email],
      first_name: 'Demandeur',
      last_name: attrs[:intitule]
    )

    submitted_at = (attrs[:validated_days_ago] + 7).days.ago

    create_token(
      INSEE_SCOPES,
      'entreprise',
      demandeur: user,
      authorization_request_params: {
        intitule: attrs[:intitule],
        external_id: attrs[:external_id],
        status: :validated,
        validated_at: attrs[:validated_days_ago].days.ago,
        first_submitted_at: submitted_at,
        siret: attrs[:siret]
      }
    )
  end

  def seed_access_logs_for(token, since_days_ago)
    since_days_ago.times do |day_offset|
      INSEE_ENDPOINTS.each do |controller|
        per_day = rand(3..15)

        per_day.times do
          AccessLog.create!(seed_access_log_attributes(token, controller, day_offset))
        end
      end
    end
  end

  def seed_access_log_attributes(token, controller, day_offset) # rubocop:disable Metrics/AbcSize
    status = %w[200 200 200 200 200 200 200 404 404 502].sample
    api_version = controller.start_with?('api_entreprise') ? 'v3' : 'v2'

    {
      timestamp: day_offset.days.ago - rand(0..23).hours - rand(0..59).minutes,
      request_id: SecureRandom.uuid,
      token:,
      path: "/v3/#{controller.split('/').last}/#{rand(10_000_000..99_999_999)}",
      controller:,
      status:,
      api_version:,
      duration: rand(80..1500).to_s,
      cached: rand < 0.15,
      params: { 'recipient' => '13002526500013' }
    }
  end

  def create_pending_insee_habilitations
    INSEE_PENDING_HABILITATIONS.each do |attrs|
      create_authorization_request(
        api: 'entreprise',
        intitule: attrs[:intitule],
        external_id: attrs[:external_id],
        status: attrs[:status],
        scopes: INSEE_SCOPES,
        first_submitted_at: attrs[:submitted_days_ago].days.ago,
        validated_at: attrs[:validated_days_ago]&.days&.ago,
        siret: attrs[:siret]
      )
    end
  end

  def load_all_models!
    Rails.root.glob('app/models/**/*.rb').each { |f| require f }
  end
end
