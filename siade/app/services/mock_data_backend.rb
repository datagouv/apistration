require 'singleton'
require 'yaml'
require 'json'

class MockDataBackend
  include Singleton

  def initialize
    super
    @endpoints = {}
  end

  def self.get_response_for(operation_id, params)
    instance.get_response_for(operation_id, params)
  end

  def get_response_for(operation_id, params)
    @payloads_paths ||= fetch_payloads_paths_from_github
    @endpoints[operation_id] ||= fetch_all_payloads_for(operation_id)

    @endpoints[operation_id][params.to_query]
  end

  private

  def fetch_all_payloads_for(operation_id)
    extract_payloads_files_for(operation_id).to_h do |file|
      build_final_payload(file)
    end
  end

  def extract_payloads_files_for(operation_id)
    @payloads_paths.select do |file|
      file[:path].starts_with?("payloads/#{operation_id}") &&
        yaml_file?(file[:path])
    end
  end

  def build_final_payload(file)
    content = YAML.load(extract_content_from_github(file[:sha]))

    [
      content['params'].to_query,
      {
        status: content['status'],
        payload: JSON.parse(content['payload'])
      }
    ]
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

  def github_files
    @github_files ||= github_client.tree('etalab/siade_staging_data', 'HEAD', recursive: true)[:tree]
  end

  def github_client
    @github_client ||= Octokit::Client.new
  end
end
