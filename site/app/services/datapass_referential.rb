class DatapassReferential
  CACHE_DURATION = 1.hour
  RETENTION_KEY = 'duree_conservation_donnees_caractere_personnel'.freeze
  RECIPIENTS_KEY = 'destinataire_donnees_caractere_personnel'.freeze

  Scope = Data.define(:value, :name, :group, :deprecated) do
    def label
      name.presence || value
    end
  end

  Form = Data.define(:uid, :scopes, :data) do
    def editor_specific?
      data.key?('description')
    end

    def data_retention_months
      Integer(data[RETENTION_KEY], exception: false)
    end

    def data_recipients
      data[RECIPIENTS_KEY].presence
    end
  end

  def self.client
    (AdminApientreprise.credentials[:datapass_api] in { url: String }) ? DatapassAPIClient.new : DatapassFixtureClient.new
  end

  def initialize(api, client: self.class.client)
    @api = api
    @client = client
  end

  def scopes
    fetch(:definition) { build_scopes(client.get_definition(definition_id)) }
  end

  def forms
    fetch(:formulaires) { build_forms(client.list_formulaires(definition_id)) } || []
  end

  def form(uid)
    forms.find { |form| form.uid == uid }
  end

  private

  attr_reader :api, :client

  def definition_id
    "api_#{api}"
  end

  def build_scopes(definition)
    definition.fetch('scopes').map do |scope|
      Scope.new(value: scope.fetch('value'), name: scope['name'], group: scope['group'], deprecated: scope['deprecated'] == true)
    end
  end

  def build_forms(formulaires)
    formulaires.map do |form|
      data = form['data'] || {}

      Form.new(uid: form.fetch('uid'), scopes: data.fetch('scopes', nil).to_a.map(&:to_s), data: data.to_hash)
    end
  end

  def fetch(resource, &)
    Rails.cache.fetch("datapass_referential/#{api}/#{resource}", expires_in: CACHE_DURATION, skip_nil: true, &)
  rescue DatapassAPIClient::Error, KeyError, TypeError, NoMethodError => e
    Sentry.capture_exception(e)
    nil
  end
end
