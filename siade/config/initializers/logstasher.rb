# :nocov:
if LogStasher.enabled?
  LogStasher.add_custom_fields do |fields|
    fields[:type] = "siade"
    fields[:domain] = request.domain
    fields[:user_agent_raw] = request.user_agent
  end

  # Controller request log custom request
  LogStasher.add_custom_fields_to_request_context do |fields|
    controller_name = request.params['controller']

    is_api_request =
      controller_name =~ /\Aapi\//


    if is_api_request
      fields[:api_version] = controller_name.split('/')[1]
    end
  end

  # /!\
  # On ActiveSupport notification
  # --> Theses lines haven't any spec, handle with caution

  # Log the backup used for this request
  LogStasher.watch('response') do |name, start, finish, id, payload, store|
    payload.each do |k,v|
      store[k] = v
    end
  end

  # Log the user access informations & jwt usage
  LogStasher.watch('user_access') do |name, start, finish, id, payload, store|
    payload.each do |k,v|
      store[k] = v
    end
  end

  # Log the provider http code
  LogStasher.watch('provider_http_code') do |name, start, finish, id, payload, store|
    store[payload[:provider_name]] = payload[:http_code]
  end
  # /!\
end
# :nocov:
