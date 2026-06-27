require 'yaml'
require 'json'
require 'cgi'
require 'payloads_helpers'

# Builds a single self-contained, offline static HTML catalog of every staging
# mock fixture (mocks/explorer.html). All fixture data is inlined as a JSON blob
# in a <script> tag; the page needs no server, no network, and no gems.
#
# Stdlib-only by design: it must run anywhere `ruby` exists, independent of the
# mocks Gemfile bundle.
class GenerateExplorer
  include PayloadsHelpers

  AUTH = {
    'api_entreprise' => {
      base: 'https://staging.entreprise.api.gouv.fr',
      header: 'Authorization: Bearer $token'
    },
    'api_particulier' => {
      base: 'https://staging.particulier.api.gouv.fr',
      header: 'X-Api-Key: $token'
    }
  }.freeze

  def initialize
    @skipped = []
    @folders_processed = 0
    @case_count = 0
    @curl_count = 0
  end

  attr_reader :skipped, :folders_processed, :case_count, :curl_count

  def perform
    readme_map = parse_readme_map

    endpoints = []
    france_connect = nil

    payload_folders.each do |folder|
      cases = load_cases(folder)
      next if cases.nil?

      if folder == 'france_connect'
        france_connect = { folder: folder, cases: cases }
        @folders_processed += 1
        next
      end

      meta = readme_map[folder] || infer_meta(folder)
      api_kind = meta[:api] # 'api_entreprise' | 'api_particulier'

      cases.each do |c|
        c[:curl] = build_curl(meta[:url], api_kind, c[:params])
        @curl_count += 1 if c[:curl]
      end

      endpoints << {
        folder: folder,
        label: meta[:label],
        url: meta[:url],
        api: api_kind,
        version: meta[:version],
        in_readme: meta[:in_readme],
        cases: cases
      }
      @folders_processed += 1
    end

    data = {
      generated_at: Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ'),
      counts: {
        endpoints: endpoints.size,
        cases: @case_count,
        curls: @curl_count,
        skipped: @skipped.size
      },
      auth: AUTH.transform_values { |v| { base: v[:base], header: v[:header] } },
      endpoints: endpoints.sort_by { |e| [e[:api].to_s, e[:version].to_s, e[:label].to_s] },
      france_connect: france_connect
    }

    File.write(html_path, render_html(data))
    data[:counts]
  end

  private

  def payload_folders
    Dir.children(File.expand_path('payloads', root_path))
       .select { |c| File.directory?(File.expand_path("payloads/#{c}", root_path)) }
       .sort
  end

  # Loads every YAML fixture in a folder. Per-file rescue: a malformed fixture is
  # counted as skipped and does not abort the run.
  def load_cases(folder)
    files = Dir[File.expand_path("payloads/#{folder}/*.y*ml", root_path)].sort
    return [] if files.empty? && folder != 'france_connect'

    files.map do |path|
      load_case(folder, path)
    end.compact
  end

  def load_case(folder, path)
    raw = YAML.load_file(path)
    unless raw.is_a?(Hash)
      @skipped << { file: rel(path), reason: 'not a YAML mapping' }
      return nil
    end

    params = raw['params'].is_a?(Hash) ? raw['params'] : {}

    response = nil
    if raw['payload']
      begin
        response = JSON.parse(raw['payload'])
      rescue JSON::ParserError => e
        @skipped << { file: rel(path), reason: "invalid JSON payload: #{e.message[0, 80]}" }
        return nil
      end
    end

    @case_count += 1
    {
      file: File.basename(path),
      title: raw['title'],
      description: raw['description'],
      example: raw['example'],
      status: raw['status'],
      params: params,
      match_key: to_query(deep_downcase(params)),
      response: response
    }
  rescue Psych::Exception => e
    @skipped << { file: rel(path), reason: "YAML parse error: #{e.message[0, 80]}" }
    nil
  rescue StandardError => e
    @skipped << { file: rel(path), reason: "#{e.class}: #{e.message[0, 80]}" }
    nil
  end

  # Parses payloads/README.md. Lines look like:
  #   * [Human Label](folder_name) (`/url/path`)
  # grouped under `## API Particulier V2`, `## API Entreprise v3+`, etc.
  # The section header gives the API family + version label; the folder-name
  # prefix is the authoritative version (a v4 folder can sit under a V3 header).
  def parse_readme_map
    path = File.expand_path('payloads/README.md', root_path)
    return {} unless File.exist?(path)

    map = {}
    current_api = nil

    File.foreach(path) do |line|
      if (m = line.match(/^##\s+API\s+(Entreprise|Particulier)/i))
        current_api = m[1].downcase == 'entreprise' ? 'api_entreprise' : 'api_particulier'
        next
      end

      m = line.match(/^\*\s+\[(.+?)\]\(([a-z0-9_]+)\)\s+\(`([^`]+)`\)/)
      next unless m

      label, folder, url = m[1], m[2], m[3]
      api = current_api || (folder.start_with?('api_entreprise') ? 'api_entreprise' : 'api_particulier')
      map[folder] = {
        label: label,
        url: url,
        api: api,
        version: version_from_folder(folder),
        in_readme: true
      }
    end

    map
  end

  # Fallback metadata for folders absent from README (none today besides
  # france_connect, but keeps the generator robust to future additions).
  def infer_meta(folder)
    api = folder.start_with?('api_entreprise') ? 'api_entreprise' : 'api_particulier'
    {
      label: folder,
      url: nil,
      api: api,
      version: version_from_folder(folder),
      in_readme: false
    }
  end

  def version_from_folder(folder)
    m = folder.match(/^api_(?:entreprise|particulier)_(v\d+)_/)
    m ? m[1] : nil
  end

  # cURL for the staging endpoint, params as -G -d pairs. $token placeholder.
  def build_curl(url, api_kind, params)
    return nil unless url && AUTH.key?(api_kind)

    auth = AUTH[api_kind]
    parts = ["curl -G '#{auth[:base]}#{url}'", "-H '#{auth[:header]}'"]
    flatten_query(params).each { |k, v| parts << "-d '#{k}=#{v}'" }
    parts.join(" \\\n  ")
  end

  def flatten_query(params)
    params.flat_map do |k, v|
      if v.is_a?(Array)
        v.map { |e| ["#{k}[]", e.to_s] }
      else
        [[k.to_s, v.to_s]]
      end
    end
  end

  # Replicates ActiveSupport Hash#to_query (used by MockDataBackend as the
  # fixture index key): each pair URL-escaped, arrays expand to key[]=v. Sorted
  # by top-level KEY only — array element order is preserved within a key, like
  # the real engine. (A flat `.sort` over the whole pair list would reorder
  # multi-element arrays and diverge from ActiveSupport.)
  def to_query(hash)
    hash.sort_by { |key, _| key.to_s }.flat_map do |key, value|
      if value.is_a?(Array)
        if value.empty?
          ["#{CGI.escape(key.to_s)}%5B%5D="]
        else
          value.map { |e| "#{CGI.escape("#{key}[]")}=#{CGI.escape(e.to_s)}" }
        end
      else
        ["#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"]
      end
    end.join('&')
  end

  # Mirrors MockDataBackend#deep_downcase: downcase String leaves only, recursing
  # into hashes and arrays; Integers and other scalars untouched.
  def deep_downcase(value)
    case value
    when Hash then value.transform_values { |v| deep_downcase(v) }
    when Array then value.map { |v| deep_downcase(v) }
    when String then value.downcase
    else value
    end
  end

  def rel(path)
    path.sub("#{root_path}/", '')
  end

  def html_path
    File.expand_path('explorer.html', root_path)
  end

  def render_html(data)
    json = JSON.generate(data)
    # </script> inside the JSON blob would close the tag early; escape it.
    safe_json = json.gsub('</', '<\/')

    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Staging Mock Explorer</title>
      <style>#{css}</style>
      </head>
      <body>
      <header>
        <h1>Staging Mock Explorer <span class="muted" id="genmeta"></span></h1>
        <p class="muted">Offline catalog of the staging mock fixtures. Pick a token with
        <code>token=`curl &lt;host&gt;/mocks/tokens/default`</code> then paste it where the cURL says <code>$token</code>.</p>
      </header>

      <nav id="tabs">
        <button class="tab active" data-tab="catalog">Catalog</button>
        <button class="tab" data-tab="tester">Match-Tester</button>
        <button class="tab" data-tab="fc">FranceConnect tokens</button>
      </nav>

      <section id="catalog" class="panel active">
        <div class="toolbar">
          <input id="search" type="search" placeholder="Search label, URL, param, description, status…" autocomplete="off">
          <select id="f-api"><option value="">All APIs</option></select>
          <select id="f-version"><option value="">All versions</option></select>
          <select id="f-status"><option value="">All statuses</option></select>
          <span class="muted" id="catalog-count"></span>
        </div>
        <div id="endpoints"></div>
      </section>

      <section id="tester" class="panel">
        <h2>Match-Tester</h2>
        <p class="muted">Replicates the real backend rule: a request matches a fixture iff the
        <strong>downcased</strong> param set is exactly equal (order-independent) to the fixture's params.
        No partial match.</p>
        <div class="tester-grid">
          <label>Endpoint
            <select id="t-endpoint"></select>
          </label>
          <label>Params (one <code>key=value</code> per line; repeat a key for array values, e.g. <code>prenoms[]=PIERRE</code>)
            <textarea id="t-params" rows="10" placeholder="siret=13002526500001&#10;year=2022"></textarea>
          </label>
          <div class="tester-actions">
            <button id="t-run">Test match</button>
            <button id="t-prefill" class="secondary">Prefill from first case</button>
          </div>
        </div>
        <div id="t-result"></div>
      </section>

      <section id="fc" class="panel">
        <h2>FranceConnect tokens</h2>
        <p class="muted">Token → identity mapping fixtures (not a queryable endpoint).</p>
        <div id="fc-list"></div>
      </section>

      <script id="data" type="application/json">#{safe_json}</script>
      <script>#{js}</script>
      </body>
      </html>
    HTML
  end

  def css
    <<~CSS
      :root{--bg:#0f1117;--card:#1a1d29;--card2:#222634;--fg:#e6e8ee;--muted:#8b90a3;--accent:#5b8def;--ok:#3ec47a;--warn:#e0a93b;--err:#e0556b;--border:#2c3142}
      *{box-sizing:border-box}
      body{margin:0;font:14px/1.5 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;background:var(--bg);color:var(--fg)}
      header{padding:18px 24px 8px}
      h1{font-size:20px;margin:0 0 4px}
      h2{font-size:16px;margin:0 0 8px}
      .muted{color:var(--muted);font-weight:400;font-size:12px}
      code{background:var(--card2);padding:1px 5px;border-radius:4px;font-size:12px}
      nav#tabs{display:flex;gap:4px;padding:0 24px;border-bottom:1px solid var(--border)}
      .tab{background:none;border:none;color:var(--muted);padding:10px 14px;cursor:pointer;font-size:13px;border-bottom:2px solid transparent}
      .tab.active{color:var(--fg);border-bottom-color:var(--accent)}
      .panel{display:none;padding:18px 24px 60px}
      .panel.active{display:block}
      .toolbar{display:flex;gap:8px;flex-wrap:wrap;align-items:center;margin-bottom:16px}
      input,select,textarea,button{font:inherit}
      input,select,textarea{background:var(--card);border:1px solid var(--border);color:var(--fg);padding:8px 10px;border-radius:6px}
      #search{flex:1;min-width:240px}
      textarea{width:100%;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;resize:vertical}
      button{background:var(--accent);border:none;color:#fff;padding:8px 14px;border-radius:6px;cursor:pointer}
      button.secondary{background:var(--card2);color:var(--fg);border:1px solid var(--border)}
      button:hover{filter:brightness(1.1)}
      .endpoint{background:var(--card);border:1px solid var(--border);border-radius:8px;margin-bottom:10px;overflow:hidden}
      .ep-head{padding:12px 14px;cursor:pointer;display:flex;gap:10px;align-items:center;flex-wrap:wrap}
      .ep-head:hover{background:var(--card2)}
      .ep-title{font-weight:600}
      .pill{font-size:11px;padding:1px 7px;border-radius:10px;background:var(--card2);color:var(--muted);border:1px solid var(--border)}
      .ep-url{font-family:ui-monospace,monospace;font-size:12px;color:var(--accent)}
      .ep-body{padding:0 14px 8px;display:none}
      .endpoint.open .ep-body{display:block}
      .case{border-top:1px solid var(--border);padding:12px 0}
      .case-head{display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin-bottom:6px}
      .badge{font-size:11px;font-weight:600;padding:1px 8px;border-radius:10px;color:#fff}
      .s2{background:var(--ok)} .s4{background:var(--warn)} .s5{background:var(--err)} .s0{background:var(--muted)}
      .case-file{font-family:ui-monospace,monospace;font-size:12px;color:var(--muted)}
      table.params{border-collapse:collapse;margin:6px 0;font-size:12px}
      table.params td{border:1px solid var(--border);padding:3px 8px}
      table.params td:first-child{color:var(--muted);font-family:ui-monospace,monospace}
      pre{background:#0b0d13;border:1px solid var(--border);border-radius:6px;padding:10px;overflow:auto;font-size:12px;margin:6px 0;max-height:280px}
      .curl-row{display:flex;gap:8px;align-items:flex-start;margin-top:6px}
      .curl-row pre{flex:1;margin:0}
      .copy{white-space:nowrap}
      details summary{cursor:pointer;color:var(--muted);font-size:12px;margin:6px 0}
      .tester-grid{display:flex;flex-direction:column;gap:12px;max-width:760px}
      .tester-grid label{display:flex;flex-direction:column;gap:4px;font-size:12px;color:var(--muted)}
      .tester-actions{display:flex;gap:8px}
      #t-result{margin-top:18px;max-width:900px}
      .result-box{border-radius:8px;border:1px solid var(--border);padding:14px;margin-bottom:12px}
      .result-ok{border-color:var(--ok)} .result-err{border-color:var(--err)}
      .result-title{font-weight:600;font-size:15px;margin-bottom:8px}
      .diff td{padding:3px 8px;border:1px solid var(--border);font-family:ui-monospace,monospace;font-size:12px}
      .diff .add{color:var(--ok)} .diff .miss{color:var(--err)} .diff .extra{color:var(--warn)} .diff .same{color:var(--muted)}
      .hidden{display:none!important}
    CSS
  end

  def js
    <<~'JS'
      const DATA = JSON.parse(document.getElementById('data').textContent);
      const $ = (s, r = document) => r.querySelector(s);
      const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
      const esc = (s) => String(s == null ? '' : s).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
      const statusClass = (s) => { const n = String(s || '')[0]; return n === '2' ? 's2' : n === '4' ? 's4' : n === '5' ? 's5' : 's0'; };

      $('#genmeta').textContent = `· ${DATA.counts.endpoints} endpoints · ${DATA.counts.cases} cases · ${DATA.counts.curls} cURLs · ${DATA.counts.skipped} skipped · ${DATA.generated_at}`;

      // ---- Tabs ----
      $$('.tab').forEach((t) => t.addEventListener('click', () => {
        $$('.tab').forEach((x) => x.classList.remove('active'));
        $$('.panel').forEach((x) => x.classList.remove('active'));
        t.classList.add('active');
        $('#' + t.dataset.tab).classList.add('active');
      }));

      // ---- Matching engine (mirrors MockDataBackend) ----
      // ActiveSupport Hash#to_query over downcased string leaves.
      function deepDowncase(v) {
        if (Array.isArray(v)) return v.map(deepDowncase);
        if (v && typeof v === 'object') { const o = {}; for (const k in v) o[k] = deepDowncase(v[k]); return o; }
        if (typeof v === 'string') return v.toLowerCase();
        return v;
      }
      // Mirror Ruby CGI.escape: space -> '+', and ! ' ( ) * ~ percent-encoded
      // (encodeURIComponent leaves these unescaped / encodes space as %20).
      function cgiEscape(s) {
        return encodeURIComponent(String(s))
          .replace(/%20/g, '+')
          .replace(/[!'()*~]/g, (c) => '%' + c.charCodeAt(0).toString(16).toUpperCase());
      }
      function toQuery(params) {
        // Sort by top-level KEY only; preserve array element order within a key
        // (matches ActiveSupport / the real engine — a flat pair sort would not).
        const pairs = [];
        Object.keys(params).sort().forEach((k) => {
          const v = params[k];
          if (Array.isArray(v)) {
            if (v.length === 0) pairs.push(cgiEscape(k) + '%5B%5D=');
            else v.forEach((e) => pairs.push(cgiEscape(k + '[]') + '=' + cgiEscape(e)));
          } else {
            pairs.push(cgiEscape(k) + '=' + cgiEscape(v));
          }
        });
        return pairs.join('&');
      }
      function matchKey(params) { return toQuery(deepDowncase(params)); }

      // ---- Catalog ----
      const ALL = [];
      DATA.endpoints.forEach((ep) => ep.cases.forEach((c) => ALL.push({ ep, c })));

      const apis = [...new Set(DATA.endpoints.map((e) => e.api).filter(Boolean))].sort();
      const versions = [...new Set(DATA.endpoints.map((e) => e.version).filter(Boolean))].sort();
      const statuses = [...new Set(ALL.map((x) => x.c.status).filter((s) => s != null))].sort((a, b) => a - b);
      apis.forEach((a) => $('#f-api').insertAdjacentHTML('beforeend', `<option value="${esc(a)}">${esc(a)}</option>`));
      versions.forEach((v) => $('#f-version').insertAdjacentHTML('beforeend', `<option value="${esc(v)}">${esc(v)}</option>`));
      statuses.forEach((s) => $('#f-status').insertAdjacentHTML('beforeend', `<option value="${esc(s)}">${esc(s)}</option>`));

      function caseMatchesSearch(ep, c, q) {
        if (!q) return true;
        const hay = [ep.label, ep.url, ep.api, ep.version, c.description, c.title, c.status, c.file,
          ...Object.entries(c.params).flat(2)].join(' ').toLowerCase();
        return hay.includes(q);
      }

      function paramTable(params) {
        const rows = Object.entries(params).map(([k, v]) =>
          `<tr><td>${esc(k)}</td><td>${esc(Array.isArray(v) ? JSON.stringify(v) : v)}</td></tr>`).join('');
        return rows ? `<table class="params">${rows}</table>` : '<p class="muted">No params</p>';
      }

      function renderCatalog() {
        const q = $('#search').value.trim().toLowerCase();
        const fApi = $('#f-api').value, fVer = $('#f-version').value, fStatus = $('#f-status').value;
        const host = $('#endpoints');
        host.innerHTML = '';
        let shownCases = 0, shownEps = 0;

        DATA.endpoints.forEach((ep) => {
          if (fApi && ep.api !== fApi) return;
          if (fVer && ep.version !== fVer) return;
          const cases = ep.cases.filter((c) => {
            if (fStatus && String(c.status) !== fStatus) return false;
            return caseMatchesSearch(ep, c, q);
          });
          if (cases.length === 0) return;
          shownEps++; shownCases += cases.length;

          const casesHtml = cases.map((c) => {
            const curl = c.curl
              ? `<div class="curl-row"><pre>${esc(c.curl)}</pre><button class="copy secondary" data-curl="${esc(c.curl)}">Copy cURL</button></div>`
              : '<p class="muted">No cURL (endpoint URL unknown)</p>';
            const resp = c.response != null
              ? `<details><summary>Response body</summary><pre>${esc(JSON.stringify(c.response, null, 2))}</pre></details>`
              : '<p class="muted">No response body</p>';
            return `<div class="case">
              <div class="case-head">
                <span class="badge ${statusClass(c.status)}">${esc(c.status == null ? '—' : c.status)}</span>
                <span class="case-file">${esc(c.file)}</span>
                <span>${esc(c.description || c.title || '')}</span>
              </div>
              ${paramTable(c.params)}
              ${curl}
              ${resp}
            </div>`;
          }).join('');

          const flag = ep.in_readme ? '' : '<span class="pill" title="not in payloads/README.md (default payload)">no-readme</span>';
          host.insertAdjacentHTML('beforeend', `<div class="endpoint">
            <div class="ep-head">
              <span class="ep-title">${esc(ep.label)}</span>
              ${ep.api ? `<span class="pill">${esc(ep.api.replace('api_', ''))}</span>` : ''}
              ${ep.version ? `<span class="pill">${esc(ep.version)}</span>` : ''}
              <span class="pill">${cases.length} case${cases.length > 1 ? 's' : ''}</span>
              ${flag}
              ${ep.url ? `<span class="ep-url">${esc(ep.url)}</span>` : ''}
            </div>
            <div class="ep-body">${casesHtml}</div>
          </div>`);
        });

        // auto-open when filtering narrows results
        if (q || fApi || fVer || fStatus) $$('.endpoint', host).forEach((e) => e.classList.add('open'));
        $('#catalog-count').textContent = `${shownEps} endpoints · ${shownCases} cases`;
      }

      $('#endpoints').addEventListener('click', (e) => {
        if (e.target.classList.contains('copy')) {
          navigator.clipboard.writeText(e.target.dataset.curl).then(() => {
            const o = e.target.textContent; e.target.textContent = 'Copied!';
            setTimeout(() => (e.target.textContent = o), 1200);
          });
          return;
        }
        const head = e.target.closest('.ep-head');
        if (head) head.parentElement.classList.toggle('open');
      });

      ['input', 'change'].forEach((ev) => {
        $('#search').addEventListener(ev, renderCatalog);
        $('#f-api').addEventListener(ev, renderCatalog);
        $('#f-version').addEventListener(ev, renderCatalog);
        $('#f-status').addEventListener(ev, renderCatalog);
      });
      renderCatalog();

      // ---- Match-Tester ----
      const sel = $('#t-endpoint');
      DATA.endpoints.filter((e) => e.cases.length).forEach((ep, i) => {
        sel.insertAdjacentHTML('beforeend', `<option value="${i}">${esc(ep.label)} (${esc(ep.api || '?')} ${esc(ep.version || '')})</option>`);
      });

      function parseParams(text) {
        const out = {};
        text.split(/\n/).forEach((line) => {
          line = line.trim();
          if (!line) return;
          const i = line.indexOf('=');
          if (i < 0) return;
          let k = line.slice(0, i).trim();
          const v = line.slice(i + 1).trim();
          if (k.endsWith('[]')) {
            k = k.slice(0, -2);
            (out[k] = out[k] || []).push(v);
          } else if (k in out) {
            out[k] = Array.isArray(out[k]) ? [...out[k], v] : [out[k], v];
          } else {
            out[k] = v;
          }
        });
        return out;
      }

      // nearest fixture = most downcased (key,value)-pairs in common
      function pairSet(params) {
        const dd = deepDowncase(params);
        const s = new Set();
        for (const k in dd) {
          const v = dd[k];
          if (Array.isArray(v)) v.forEach((e) => s.add(k + '=' + String(e)));
          else s.add(k + '=' + String(v));
        }
        return s;
      }

      function diffTable(reqParams, fixParams) {
        const a = deepDowncase(reqParams), b = deepDowncase(fixParams);
        const keys = [...new Set([...Object.keys(a), ...Object.keys(b)])].sort();
        const fmt = (v) => v === undefined ? '<span class="muted">—</span>' : esc(Array.isArray(v) ? JSON.stringify(v) : v);
        const rows = keys.map((k) => {
          const inA = k in a, inB = k in b;
          let cls = 'same', note = 'match';
          const av = inA ? (Array.isArray(a[k]) ? JSON.stringify(a[k]) : String(a[k])) : undefined;
          const bv = inB ? (Array.isArray(b[k]) ? JSON.stringify(b[k]) : String(b[k])) : undefined;
          if (inA && !inB) { cls = 'extra'; note = 'extra in request'; }
          else if (!inA && inB) { cls = 'miss'; note = 'missing from request'; }
          else if (av !== bv) { cls = 'miss'; note = 'value differs'; }
          return `<tr class="${cls}"><td>${esc(k)}</td><td>${fmt(a[k])}</td><td>${fmt(b[k])}</td><td>${note}</td></tr>`;
        }).join('');
        return `<table class="diff"><tr><td><b>param</b></td><td><b>your request</b></td><td><b>fixture</b></td><td><b>note</b></td></tr>${rows}</table>`;
      }

      function runTest() {
        const ep = DATA.endpoints[+sel.value];
        const reqParams = parseParams($('#t-params').value);
        const key = matchKey(reqParams);
        const hit = ep.cases.find((c) => c.match_key === key);
        const box = $('#t-result');

        if (hit) {
          box.innerHTML = `<div class="result-box result-ok">
            <div class="result-title">✅ Exact match → ${esc(hit.file)}, status ${esc(hit.status)}</div>
            <div class="muted">match key: <code>${esc(key)}</code></div>
            ${hit.response != null ? `<pre>${esc(JSON.stringify(hit.response, null, 2))}</pre>` : '<p class="muted">No response body</p>'}
          </div>`;
          return;
        }

        const reqSet = pairSet(reqParams);
        let best = null, bestScore = -1;
        ep.cases.forEach((c) => {
          const fs = pairSet(c.params);
          let common = 0;
          reqSet.forEach((p) => { if (fs.has(p)) common++; });
          if (common > bestScore) { bestScore = common; best = c; }
        });

        let html = `<div class="result-box result-err">
          <div class="result-title">❌ No exact match for this endpoint</div>
          <div class="muted">your match key: <code>${esc(key) || '(empty)'}</code></div>`;
        if (best) {
          html += `<p>Nearest fixture: <code>${esc(best.file)}</code> (status ${esc(best.status)}, ${bestScore} param pair${bestScore === 1 ? '' : 's'} in common)</p>
            ${diffTable(reqParams, best.params)}`;
        } else {
          html += '<p class="muted">This endpoint has no fixtures to compare against.</p>';
        }
        html += '</div>';
        box.innerHTML = html;
      }

      $('#t-run').addEventListener('click', runTest);
      $('#t-prefill').addEventListener('click', () => {
        const ep = DATA.endpoints[+sel.value];
        const c = ep.cases[0];
        if (!c) return;
        const lines = [];
        for (const k in c.params) {
          const v = c.params[k];
          if (Array.isArray(v)) v.forEach((e) => lines.push(`${k}[]=${e}`));
          else lines.push(`${k}=${v}`);
        }
        $('#t-params').value = lines.join('\n');
      });

      // ---- FranceConnect ----
      if (DATA.france_connect) {
        const host = $('#fc-list');
        DATA.france_connect.cases.forEach((c) => {
          host.insertAdjacentHTML('beforeend', `<div class="endpoint open">
            <div class="ep-head"><span class="ep-title">${esc(c.file)}</span>
              ${c.params && c.params.token ? `<span class="pill">token: ${esc(c.params.token)}</span>` : ''}
              <span>${esc(c.title || c.description || '')}</span></div>
            <div class="ep-body"><div class="case">
              ${c.response != null ? `<details><summary>Introspection payload</summary><pre>${esc(JSON.stringify(c.response, null, 2))}</pre></details>` : ''}
            </div></div>
          </div>`);
        });
      } else {
        $('[data-tab="fc"]').classList.add('hidden');
      }
    JS
  end
end
