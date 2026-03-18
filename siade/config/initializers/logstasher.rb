if LogStasher.enabled?
  LogStasher.add_custom_fields do |fields|
    fields[:type] = "siade"
    fields[:domain] = request.domain
    fields[:user_agent_raw] = request.user_agent
  end

  LogStasher.add_custom_fields_to_request_context do |fields|
    LogStasherFieldsBuilder.new(self, fields).perform
  end

  LogStasher.watch('user_access') do |name, start, finish, id, payload, store|
    payload.each do |k,v|
      store[k] = v
    end
  end
end
