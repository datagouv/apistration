require 'faraday'
require 'json'

class SentryClient
  BASE_URI = 'https://errors.data.gouv.fr'.freeze
  ORG_SLUG = 'sentry'.freeze
  PROJECT_SLUG = 'siade-backend'.freeze
  TOKEN_FILE = '.sentry_token'.freeze

  def initialize
    @token = load_token
    @connection = build_connection
  end

  def issues(query: 'is:unresolved', stats_period: '14d')
    response = @connection.get(
      "/api/0/projects/#{ORG_SLUG}/#{PROJECT_SLUG}/issues/",
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
    response = @connection.get("/api/0/projects/#{ORG_SLUG}/#{PROJECT_SLUG}/events/#{event_id}/")
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
    token_path = File.expand_path(TOKEN_FILE, Dir.pwd)
    unless File.exist?(token_path)
      abort <<~MSG
        #{TOKEN_FILE} not found.

        Create a token at: #{BASE_URI}/settings/account/api/auth-tokens/
        Required scopes: event:read, project:read

        Save token to #{TOKEN_FILE}:
          echo "your_token" > #{TOKEN_FILE}
      MSG
    end
    File.read(token_path).strip
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
