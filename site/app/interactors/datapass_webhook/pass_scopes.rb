module DatapassWebhook::PassScopes
  private

  def pass_scopes
    DatapassScopes.normalize(Hash(context.data.dig('pass', 'scopes')).filter_map { |code, checked| code if checked })
  end
end
