class DatapassFixtureClient
  def get_definition(definition_id)
    { 'scopes' => referential['scopes'].select { |scope| definition_id == "api_#{scope['api']}" } }
  end

  def list_formulaires(definition_id)
    referential['forms'].select { |form| definition_id == "api_#{form['api']}" }
  end

  private

  def referential
    @referential ||= JSON.parse(Rails.root.join('db/seeds/datapass_referential.json').read)
  end
end
