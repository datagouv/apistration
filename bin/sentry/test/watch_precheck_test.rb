# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'

load File.expand_path('../watch-precheck', __dir__)

class SentryWatchPrecheckTest < Minitest::Test
  FakeResponse = Struct.new(:code, :body, :content_type, :headers) do
    def [](name)
      headers.to_h[name]
    end
  end

  class FakeSentry
    PAGE_SIZE = 25
    ME = '1'

    attr_reader :notes

    def initialize(issues, regressions, notes, racing_teammate)
      @issues = issues
      @regressions = regressions
      @notes = notes.transform_values { |claims| claims.map { |user, at| note(user, at) } }
      @racing_teammate = racing_teammate
    end

    def request(request)
      path, query_string = request.path.split('?', 2)
      return json({ 'user' => { 'id' => ME } }) if path == '/api/0/'
      return claim(Regexp.last_match(1)) if request.method == 'POST' && path =~ %r{/issues/(\d+)/comments/\z}
      return withdraw(Regexp.last_match(1), Regexp.last_match(2)) if request.method == 'DELETE' && path =~ %r{/issues/(\d+)/comments/(\d+)/\z}
      return activities(Regexp.last_match(1)) if path =~ %r{/issues/(\d+)/activities/}

      params = URI.decode_www_form(query_string.to_s).to_h
      project = path[%r{/projects/sentry/([^/]+)/issues/}, 1]
      page(@issues.select { |issue| issue['project'] == project && matches?(issue, params.fetch('query')) }, params['cursor'].to_i)
    end

    def claims_by(user)
      @notes.transform_values { |claims| claims.count { |claim| claim.dig('user', 'id') == user } }.reject { |_, count| count.zero? }
    end

    def settle
      @committing&.call
      @committing = nil
    end

    private

    def claim(issue_id)
      if @racing_teammate
        earlier = note(@racing_teammate, Time.now - 1)
        @committing = -> { notes_of(issue_id).unshift(earlier) }
        @racing_teammate = nil
      end
      notes_of(issue_id) << note(ME, Time.now)
      FakeResponse.new('201', JSON.generate(notes_of(issue_id).last), 'application/json')
    end

    def withdraw(issue_id, note_id)
      notes_of(issue_id).reject! { |claim| claim['id'] == note_id }
      FakeResponse.new('204', '', nil)
    end

    def notes_of(issue_id)
      @notes[issue_id] ||= []
    end

    def note(user, at)
      @next_note_id = @next_note_id.to_i + 1
      { 'id' => @next_note_id.to_s, 'type' => 'note', 'user' => { 'id' => user }, 'data' => { 'text' => SentryWatchPrecheck::CLAIM_NOTE }, 'dateCreated' => at.iso8601(6) }
    end

    def activities(issue_id)
      regressions = [@regressions[issue_id]].flatten.compact.map { |at| { 'type' => 'set_regression', 'dateCreated' => at.iso8601 } }
      json({ 'activity' => [{ 'type' => 'note', 'dateCreated' => Time.now.iso8601, 'data' => { 'text' => 'a human comment' } }, *regressions, *notes_of(issue_id)] })
    end

    def matches?(issue, query)
      query.split.all? do |term|
        case term
        when 'is:regressed' then @regressions.key?(issue['id'])
        when /\AfirstSeen:>=(.+)\z/ then Time.iso8601(issue['firstSeen']) >= Time.iso8601("#{Regexp.last_match(1)}Z")
        when /\AlastSeen:>=(.+)\z/ then Time.iso8601(issue['lastSeen']) >= Time.iso8601("#{Regexp.last_match(1)}Z")
        else true
        end
      end
    end

    def page(issues, offset)
      next_offset = offset + PAGE_SIZE
      more = next_offset < issues.size
      json(issues[offset, PAGE_SIZE].map { |issue| issue.except('project') },
           'Link' => %(<next>; rel="next"; results="#{more}"; cursor="#{next_offset}"))
    end

    def json(body, headers = {})
      FakeResponse.new('200', JSON.generate(body), 'application/json', headers)
    end
  end

  FailingSentry = Struct.new(:answer) do
    def request(_request)
      answer.call
    end
  end

  LAST_SUCCESS_AT = Time.utc(2026, 11, 4, 12, 0, 0)
  TEAMMATE = '2'

  def setup
    @previous_env = ENV.to_h.slice('AGS_JOB_STATE_DIR', 'AGS_LAST_SUCCESS_AT')
    @workdir = Dir.mktmpdir
    File.write(File.join(@workdir, '.sentry_token'), 'token')
    File.write(File.join(@workdir, '.sentry_write_token'), 'write token')
    Dir.mkdir(File.join(@workdir, 'state'))
    ENV['AGS_JOB_STATE_DIR'] = File.join(@workdir, 'state')
    ENV['AGS_LAST_SUCCESS_AT'] = LAST_SUCCESS_AT.iso8601
  end

  def teardown
    ENV.delete('AGS_JOB_STATE_DIR')
    ENV.delete('AGS_LAST_SUCCESS_AT')
    ENV.update(@previous_env)
    FileUtils.rm_rf(@workdir)
  end

  def test_an_issue_first_seen_since_the_last_success_is_handed_to_the_job
    issues = [
      issue('1', project: 'siade-site', first_seen: LAST_SUCCESS_AT + 60),
      issue('2', project: 'siade-site', first_seen: LAST_SUCCESS_AT - 60),
    ]
    with_sentry(issues:) do |sentry|
      exit_code, handed = run_precheck_and_parse

      assert_equal 0, exit_code
      assert_equal [['siade-site', '1', false]], handed.map { |i| [i['project'], i['id'], i['regressed']] }
      assert_equal({ '1' => 1 }, sentry.claims_by(FakeSentry::ME))
    end
  end

  def test_every_new_issue_is_handed_when_they_span_several_pages
    issues = (1..30).map { |id| issue(id.to_s, first_seen: LAST_SUCCESS_AT + id) }
    with_sentry(issues:) do
      _, handed = run_precheck_and_parse

      assert_equal (1..30).map(&:to_s), handed.map { |i| i['id'] }
    end
  end

  def test_an_issue_both_new_and_regressed_is_handed_once
    issues = [issue('1', first_seen: LAST_SUCCESS_AT + 60, last_seen: LAST_SUCCESS_AT + 120)]
    with_sentry(issues:, regressions: { '1' => LAST_SUCCESS_AT + 120 }) do
      exit_code, handed = run_precheck_and_parse

      assert_equal 0, exit_code
      assert_equal [['1', true]], handed.map { |i| [i['id'], i['regressed']] }
    end
  end

  def test_a_regression_since_the_last_success_is_handed_even_when_its_event_was_ingested_late
    issues = [issue('1', first_seen: LAST_SUCCESS_AT - 86_400, last_seen: LAST_SUCCESS_AT - 60)]
    with_sentry(issues:, regressions: { '1' => [LAST_SUCCESS_AT - 3600, LAST_SUCCESS_AT + 60] }) do
      _, handed = run_precheck_and_parse

      assert_equal [['1', true]], handed.map { |i| [i['id'], i['regressed']] }
    end
  end

  def test_a_regression_older_than_the_last_success_is_not_handed_again
    issues = [issue('1', first_seen: LAST_SUCCESS_AT - 86_400, last_seen: LAST_SUCCESS_AT + 120)]
    with_sentry(issues:, regressions: { '1' => LAST_SUCCESS_AT - 60 }) do
      assert_equal [1, "no new or regressed issue\n", ''], run_precheck
    end
  end

  def test_an_issue_a_teammate_claimed_since_it_appeared_is_left_to_them
    issues = [issue('1', first_seen: LAST_SUCCESS_AT + 60)]
    with_sentry(issues:, notes: { '1' => [[TEAMMATE, LAST_SUCCESS_AT + 120]] }) do |sentry|
      assert_equal [1, "every new or regressed issue is claimed by a teammate: SIADE-BACKEND-1\n", ''], run_precheck
      assert_empty sentry.claims_by(FakeSentry::ME)
    end
  end

  def test_when_a_teammate_claims_the_same_issue_at_the_same_time_the_first_claim_wins_even_if_it_shows_up_later
    issues = [issue('1', first_seen: LAST_SUCCESS_AT + 60), issue('2', first_seen: LAST_SUCCESS_AT + 60)]
    with_sentry(issues:, racing_teammate: TEAMMATE) do |sentry|
      _, handed = run_precheck_and_parse

      assert_equal ['2'], handed.map { |i| i['id'] }
      assert_equal({ '2' => 1 }, sentry.claims_by(FakeSentry::ME))
      assert_equal({ '1' => 1 }, sentry.claims_by(TEAMMATE))
    end
  end

  def test_a_teammate_claim_holds_a_new_issue_whose_first_event_was_dated_by_a_clock_running_ahead
    issues = [issue('1', first_seen: LAST_SUCCESS_AT + 600)]
    with_sentry(issues:, notes: { '1' => [[TEAMMATE, LAST_SUCCESS_AT + 60]] }) do |sentry|
      assert_equal 1, run_precheck.first
      assert_empty sentry.claims_by(FakeSentry::ME)
    end
  end

  def test_a_claim_older_than_the_regression_does_not_hold_the_issue
    issues = [issue('1', first_seen: LAST_SUCCESS_AT - 86_400, last_seen: LAST_SUCCESS_AT + 60)]
    with_sentry(issues:, regressions: { '1' => LAST_SUCCESS_AT + 60 }, notes: { '1' => [[TEAMMATE, LAST_SUCCESS_AT - 3600]] }) do |sentry|
      _, handed = run_precheck_and_parse

      assert_equal [['1', true]], handed.map { |i| [i['id'], i['regressed']] }
      assert_equal({ '1' => 1 }, sentry.claims_by(FakeSentry::ME))
    end
  end

  def test_an_issue_claimed_by_a_run_that_failed_is_handed_again_without_a_second_claim
    issues = [issue('1', first_seen: LAST_SUCCESS_AT + 60)]
    with_sentry(issues:, notes: { '1' => [[FakeSentry::ME, LAST_SUCCESS_AT + 120]] }) do |sentry|
      _, handed = run_precheck_and_parse

      assert_equal ['1'], handed.map { |i| i['id'] }
      assert_equal({ '1' => 1 }, sentry.claims_by(FakeSentry::ME))
    end
  end


  def test_nothing_new_skips_the_run_without_error
    with_sentry do
      assert_equal [1, "no new or regressed issue\n", ''], run_precheck
    end
  end

  def test_an_unavailable_sentry_skips_the_run_then_fails_after_30_minutes_of_outage
    with_sentry_failing(-> { maintenance_page }) do
      run_precheck_every_5_minutes_until(30)

      error = assert_raises(RuntimeError) { at(LAST_SUCCESS_AT + (30 * 60)) { run_precheck } }
      assert_match(/HTTP 503 since/, error.message)
    end
  end

  def test_a_past_outage_is_forgotten_once_sentry_answers_again
    with_sentry_failing(-> { maintenance_page }) { run_precheck_every_5_minutes_until(25) }
    with_sentry { at(LAST_SUCCESS_AT + (25 * 60)) { run_precheck } }

    with_sentry_failing(-> { maintenance_page }) do
      exit_code, stdout, = at(LAST_SUCCESS_AT + (30 * 60)) { run_precheck }

      assert_equal 1, exit_code
      assert_match(/Sentry API unavailable/, stdout)
    end
  end

  def test_an_unreachable_sentry_is_an_outage_too
    with_sentry_failing(-> { raise Net::OpenTimeout }) do
      exit_code, stdout, stderr = run_precheck

      assert_equal 1, exit_code
      assert_match(/Sentry API unavailable.*unreachable/, stdout)
      assert_empty stderr
    end
  end

  def test_a_missing_token_fails_at_once
    File.delete(File.join(@workdir, '.sentry_token'))
    with_sentry do
      assert_raises(Errno::ENOENT) { run_precheck }
    end
  end

  def test_a_rejected_token_fails_at_once
    with_sentry_failing(-> { FakeResponse.new('401', '{"detail":"Invalid token"}', 'application/json') }) do
      error = assert_raises(RuntimeError) { run_precheck }
      assert_match(/rejected the access token: HTTP 401/, error.message)
    end
  end

  private

  def issue(id, first_seen:, last_seen: first_seen, project: 'siade-backend')
    {
      'project' => project,
      'id' => id,
      'shortId' => "#{project.upcase}-#{id}",
      'title' => 'NoMethodError',
      'level' => 'error',
      'count' => '3',
      'firstSeen' => first_seen.iso8601,
      'lastSeen' => last_seen.iso8601,
      'permalink' => "https://errors.data.gouv.fr/organizations/sentry/issues/#{id}/",
    }
  end

  def maintenance_page
    FakeResponse.new('503', '<html><body>Service Unavailable</body></html>', 'text/html')
  end

  def with_sentry(issues: [], regressions: {}, notes: {}, racing_teammate: nil)
    sentry = FakeSentry.new(issues, regressions, notes, racing_teammate)
    replacing(Kernel, :sleep, ->(_seconds) { sentry.settle }) { stub_http(sentry) { yield sentry } }
  end

  def with_sentry_failing(answer, &)
    stub_http(FailingSentry.new(answer), &)
  end

  def stub_http(fake_sentry, &)
    replacing(Net::HTTP, :start, ->(*_args, **_options, &block) { block.call(fake_sentry) }, &)
  end

  def at(time, &)
    replacing(Time, :now, -> { time }, &)
  end

  def replacing(owner, method_name, replacement)
    original = owner.method(method_name)
    owner.define_singleton_method(method_name, &replacement)
    yield
  ensure
    owner.define_singleton_method(method_name, original)
  end

  def run_precheck_every_5_minutes_until(minutes)
    0.step(minutes - 5, 5) do |minute|
      exit_code, stdout, stderr = at(LAST_SUCCESS_AT + (minute * 60)) { run_precheck }

      assert_equal 1, exit_code
      assert_match(/Sentry API unavailable/, stdout)
      assert_empty stderr
    end
  end

  def run_precheck
    exit_code = nil
    stdout, stderr = capture_io { Dir.chdir(@workdir) { exit_code = SentryWatchPrecheck.new.run } }
    [exit_code, stdout, stderr]
  end

  def run_precheck_and_parse
    exit_code, stdout, = run_precheck
    [exit_code, JSON.parse(stdout)]
  end
end
