if LogStasher.enabled
  LogStasher.add_custom_fields do |fields|
    fields[:type] = 'admin'
    fields[:ip] = request.get_header(RawRemoteIp::ENV_KEY).to_s
    fields[:user_agent_raw] = request.user_agent
  end
end
