require 'yaml'
require 'json'

class MockDataBackend
  def self.get_response_for(operation_id, params)
    new.get_response_for(operation_id, params)
  end

  def self.get_not_found_response_for(operation_id)
    new.get_not_found_response_for(operation_id)
  end

  def self.reset!
    new.reset!
  end

  def reset!
    clean_all_operations!
    clean_payloads_paths!
  end

  def get_response_for(operation_id, params)
    fetch_all_payloads_for(operation_id)[params.to_query]
  end

  def get_not_found_response_for(operation_id)
    fetch_all_payloads_for(operation_id)['not_found']
  end

  private

  def fetch_all_payloads_for(operation_id)
    with_cache("mock_data_backend:payloads:#{operation_id}") do
      all_payloads = extract_payloads_files_for(operation_id).to_h do |file|
        build_final_payload(file)
      end

      if not_found_file(operation_id).present?
        all_payloads.merge!({
          'not_found' => build_final_payload(not_found_file(operation_id))[1]
        })
      end

      all_payloads
    end
  end

  def not_found_file(operation_id)
    extract_payloads_files_for(operation_id).find do |file|
      file[:path].ends_with?('404.yaml')
    end
  end

  def extract_payloads_files_for(operation_id)
    fetch_payloads_paths.select do |file|
      file[:path].starts_with?("payloads/#{operation_id}/") &&
        yaml_file?(file[:path])
    end
  end

  def build_final_payload(file)
    content = YAML.load(extract_content_from_github(file[:sha]))

    [
      deep_downcase(content['params']).to_query,
      {
        status: content['status'],
        payload: JSON.parse(content['payload'])
      }
    ]
  end

  def deep_downcase(hash)
    hash.deep_transform_values { |v| v.is_a?(String) ? v.downcase : v }
  end

  def fetch_payloads_paths
    with_cache('mock_data_backend:payloads_paths') do
      fetch_payloads_paths_from_github
    end
  end

  def fetch_payloads_paths_from_github
    github_files.select do |file|
      file[:path].starts_with?('payloads/') &&
        yaml_file?(file[:path])
    end
  end

  def extract_content_from_github(sha)
    content_response = github_client.blob('etalab/siade_staging_data', sha)

    if content_response[:encoding] == 'base64'
      Base64.decode64(content_response[:content])
    else
      content_response[:content]
    end
  end

  def yaml_file?(path)
    path.ends_with?('.yaml') ||
      path.ends_with?('.yml')
  end

  def with_cache(key)
    cached_value = redis_service.restore(key)

    return cached_value if cached_value.present?

    value = yield

    redis_service.dump(key, value) if value.present?

    value
  end

  def clean_all_operations!
    (redis_service.restore('mock_data_backend:payloads_paths') || []).each do |file|
      next unless file[:path].starts_with?('payloads/')

      redis_service.del("mock_data_backend:payloads:#{file[:path].split('/')[1]}")
    end
  end

  def clean_payloads_paths!
    redis_service.del('mock_data_backend:payloads_paths')
  end

  def github_files
    @github_files ||= github_client.tree('etalab/siade_staging_data', 'HEAD', recursive: true)[:tree]
  end

  def github_client
    @github_client ||= Octokit::Client.new(github_client_options)
  end

  def github_client_options
    {
      access_token: Siade.credentials[:github_personal_access_token]
    }
  rescue KeyError
    {}
  end

  def redis_service
    @redis_service ||= RedisService.new
  end
end
