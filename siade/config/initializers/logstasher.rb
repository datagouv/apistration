if LogStasher.enabled?
  LogStasher.add_custom_fields do |fields|
    fields[:type] = "siade"
    fields[:domain] = request.domain
    fields[:user_agent_raw] = request.user_agent
  end

  LogStasher.add_custom_fields_to_request_context do |fields|
    controller_name = request.params['controller']

    is_api_request = (controller_name =~ /\Aapi\//)

    if is_api_request
      fields[:api_version] = controller_name.split('/')[1]
    end

    if retriever_cached?
      fields[:retriever_cached] = 't'
    else
      fields[:retriever_cached] = 'f'
    end
  end

  LogStasher.watch('user_access') do |name, start, finish, id, payload, store|
    payload.each do |k,v|
      store[k] = v
    end
  end
end
