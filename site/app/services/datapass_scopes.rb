module DatapassScopes
  module_function

  def normalize(codes)
    scopes = codes.reject { |code| open_data?(code) }
    scopes << 'open_data' if codes.any? { |code| open_data?(code) }
    scopes.uniq
  end

  def open_data?(code)
    code.start_with?('open_data_')
  end
end
