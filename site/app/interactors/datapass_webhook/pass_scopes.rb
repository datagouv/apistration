module DatapassWebhook::PassScopes
  private

  def pass_scopes
    scopes = Hash(context.data.dig('pass', 'scopes')).filter_map { |code, checked| code if checked }
    scopes << 'open_data' if scopes.any? { |scope| scope.start_with?('open_data_') }
    scopes.reject! { |scope| scope.start_with?('open_data_') }
    scopes.uniq
  end
end
