require 'faraday'
require 'json'

class SentryClient
  BASE_URI = 'https://errors.data.gouv.fr'.freeze
  ORG_SLUG = 'sentry'.freeze
  TOKEN_FILE = '.sentry_token'.freeze
  PROJECTS = %w[siade-backend siade-site].freeze
  DEFAULT_PROJECT = 'siade-backend'.freeze

  attr_reader :project

  def initialize(project: DEFAULT_PROJECT)
    unless PROJECTS.include?(project)
      abort "Unknown project: #{project}. Valid: #{PROJECTS.join(', ')}"
    end
    @project = project
    @token = load_token
    @connection = build_connection
  end

  def backend?
    @project == 'siade-backend'
  end

  def issues(query: 'is:unresolved', stats_period: '14d')
    response = @connection.get(
      "/api/0/projects/#{ORG_SLUG}/#{@project}/issues/",
      { statsPeriod: stats_period, query: query }
    )
    response.body
  end

  def issue(issue_id)
    response = @connection.get("/api/0/issues/#{issue_id}/")
    response.body
  end

  def events(issue_id, page: 0, full: false)
    response = @connection.get(
      "/api/0/issues/#{issue_id}/events/",
      { full: full, cursor: "0:0:#{page * 100}" }
    )
    response.body
  end

  def latest_event(issue_id)
    response = @connection.get("/api/0/issues/#{issue_id}/events/latest/")
    response.body
  end

  def event(event_id)
    response = @connection.get("/api/0/projects/#{ORG_SLUG}/#{@project}/events/#{event_id}/")
    response.body
  end

  def extract_provider_error(event)
    event.dig('contexts', 'Provider error')
  end

  def extract_stacktrace(event)
    threads_entry = event['entries']&.find { |e| e['type'] == 'threads' }
    exception_entry = event['entries']&.find { |e| e['type'] == 'exception' }

    if threads_entry
      threads_entry.dig('data', 'values')&.first&.dig('stacktrace', 'frames')
    elsif exception_entry
      exception_entry.dig('data', 'values')&.first&.dig('stacktrace', 'frames')
    end
  end

  def extract_exception(event)
    exception_entry = event['entries']&.find { |e| e['type'] == 'exception' }
    return nil unless exception_entry

    exception_entry.dig('data', 'values')&.map do |v|
      { type: v['type'], value: v['value'] }
    end
  end

  def extract_request(event)
    request_entry = event['entries']&.find { |e| e['type'] == 'request' }
    return nil unless request_entry

    {
      url: request_entry.dig('data', 'url'),
      method: request_entry.dig('data', 'method'),
      query_string: request_entry.dig('data', 'query'),
      headers: request_entry.dig('data', 'headers')
    }
  end

  def format_stacktrace(frames)
    return '' unless frames&.any?

    frames.reverse.map { |frame|
      file = frame['filename'] || frame['absPath']
      line = frame['lineNo']
      func = frame['function']
      "#{file}:#{line} in `#{func}`"
    }.join("\n")
  end

  private

  def load_token
    candidates = [
      File.expand_path(TOKEN_FILE, Dir.pwd),
      File.expand_path("../../#{TOKEN_FILE}", __dir__)
    ].uniq

    path = candidates.find { |p| File.exist?(p) }
    unless path
      abort <<~MSG
        #{TOKEN_FILE} not found.

        Searched:
        #{candidates.map { |c| "  - #{c}" }.join("\n")}

        Create a token at: #{BASE_URI}/settings/account/api/auth-tokens/
        Required scopes: event:read, project:read

        Save token to #{TOKEN_FILE} (in repo root or current dir):
          echo "your_token" > #{TOKEN_FILE}
      MSG
    end
    File.read(path).strip
  end

  def build_connection
    Faraday.new(url: BASE_URI) do |conn|
      conn.response :raise_error
      conn.response :json
      conn.options.open_timeout = 30
      conn.options.timeout = 30
      conn.request :authorization, 'Bearer', @token
    end
  end
end

module SentryCli
  module_function

  def parse_project!(args)
    project = ENV['SENTRY_PROJECT'] || SentryClient::DEFAULT_PROJECT
    remaining = []
    while (arg = args.shift)
      case arg
      when '-P', '--project'
        project = args.shift
      else
        remaining << arg
      end
    end
    args.replace(remaining)
    project
  end

  def project_help
    [
      "  -P, --project NAME   Sentry project: #{SentryClient::PROJECTS.join(', ')}",
      "                       (default: #{SentryClient::DEFAULT_PROJECT}, or $SENTRY_PROJECT)"
    ].join("\n")
  end
end
