class ProviderPings
  LIST_CACHE_TTL = 1.hour
  LIST_FAILURE_CACHE_TTL = 1.minute
  CHECK_FRESHNESS = 1.minute
  CHECK_RETENTION = 15.minutes
  PROBE_DEADLINE = 15.seconds
  PROBE_LOCK_TTL = 1.minute
  OPEN_TIMEOUT = 2
  LIST_READ_TIMEOUT = 3
  CHECK_READ_TIMEOUT = 7
  UNAVAILABLE_LIST = 'unavailable'.freeze
  KNOWN_STATUSES = { 'ok' => :ok, 'maintenance' => :maintenance }.freeze

  Ping = Data.define(:name, :url)
  Check = Data.define(:status, :checked_at, :last_ok_at, :probed_at)

  def initialize(namespace)
    @namespace = namespace
  end

  def all
    @all = cached_list unless defined?(@all)
    @all
  end

  def checks
    stored = all.to_a.to_h { |ping| [ping.url, Rails.cache.read(check_key(ping.url))] }
    locks = stored.filter_map { |url, check| [url, take_probe_lock(url)] if stale?(check) }

    stored.compact.merge(probe_in_parallel(locks))
  end

  private

  def cached_list
    list = Rails.cache.read(list_key)
    list = store_list(fetch_list) if list.nil?
    list unless list == UNAVAILABLE_LIST
  end

  def store_list(list)
    Rails.cache.write(list_key, list || UNAVAILABLE_LIST, expires_in: list ? LIST_CACHE_TTL : LIST_FAILURE_CACHE_TTL)
    list || UNAVAILABLE_LIST
  end

  def fetch_list
    response = PingProbe.new(pings_url, open_timeout: OPEN_TIMEOUT, read_timeout: LIST_READ_TIMEOUT).perform
    return unless response&.code == '200'

    Array.try_convert(JSON.parse(response.body))&.filter_map { |entry| build_ping(entry) }.presence
  rescue JSON::ParserError
    nil
  end

  def build_ping(entry)
    name, url = Hash.try_convert(entry)&.values_at('name', 'url')
    name = String.try_convert(name)
    url = String.try_convert(url)

    Ping.new(name:, url:) if name.present? && url&.match?(%r{\Ahttps?://\S+\z})
  end

  def stale?(check)
    check.nil? || check.probed_at < CHECK_FRESHNESS.ago
  end

  def take_probe_lock(url)
    Rails.cache.write(probe_lock_key(url), true, unless_exist: true, expires_in: PROBE_LOCK_TTL)
  end

  def probe_in_parallel(locks)
    locks.reject { |_url, lock| lock == false }
      .map { |url, lock| Thread.new { [url, probe_and_store(url, lock_owned: lock == true)] } }
      .to_h(&:value)
  end

  def probe_and_store(url, lock_owned:)
    check = probe_within_deadline(url)
    Rails.cache.write(check_key(url), check, expires_in: CHECK_RETENTION)
    check
  ensure
    Rails.cache.delete(probe_lock_key(url)) if lock_owned
  end

  def probe_within_deadline(url)
    Timeout.timeout(PROBE_DEADLINE) { probe(url) }
  rescue StandardError
    Check.new(status: :ko, checked_at: Time.zone.now, last_ok_at: nil, probed_at: Time.zone.now)
  end

  def probe(url)
    response = PingProbe.new(url, open_timeout: OPEN_TIMEOUT, read_timeout: CHECK_READ_TIMEOUT).perform
    payload = parse_payload(response)

    Check.new(
      status: status_for(response, payload),
      checked_at: parse_time(payload['last_update']) || Time.zone.now,
      last_ok_at: parse_time(payload['last_ok_status']),
      probed_at: Time.zone.now
    )
  end

  def status_for(response, payload)
    return :ko unless response&.code == '200'

    KNOWN_STATUSES.fetch(payload['status'], :unknown)
  end

  def parse_payload(response)
    Hash.try_convert(JSON.parse(response&.body.presence || '{}')) || {}
  rescue JSON::ParserError
    {}
  end

  def parse_time(value)
    Time.zone.parse(value.to_s)
  rescue ArgumentError, RangeError
    nil
  end

  def list_key
    "provider_pings/#{@namespace}"
  end

  def check_key(url)
    "provider_pings/check/#{url}"
  end

  def probe_lock_key(url)
    "provider_pings/probing/#{url}"
  end

  def pings_url
    Kernel.const_get(@namespace.classify)::PINGS_URL
  end
end
