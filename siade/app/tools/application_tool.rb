class ApplicationTool < MCP::Tool
  def self.call(**params)
    params[:context] = params.delete(:server_context) || {}
    params = format_params(params)
    params.delete(:context)

    organizer = retriever(params)

    if organizer.success?
      text_response(organizer.bundled_data.data.to_json)
    else
      render_errors(organizer)
    end
  end

  def self.format_params(params)
    params
  end

  def self.retriever(params)
    organizer_class.call(
      params:,
      operation_id: tool_name
    )
  end

  def self.render_errors(organizer)
    text_response(::ErrorsSerializer.new(organizer.errors).as_json.to_s)
  end

  def self.scopes
    Scope.config["mcp/#{tool_name}"] || []
  end

  def self.text_response(text)
    MCP::Tool::Response.new([{ type: 'text', text: }])
  end
end
