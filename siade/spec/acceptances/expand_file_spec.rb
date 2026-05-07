RSpec.describe '.expand file', type: :acceptance do
  let(:expand_path) { Rails.root.join('.expand') }
  let(:repo_root) { Rails.root.join('..').expand_path }

  let(:entries) do
    expand_path.readlines.filter_map do |raw|
      line = raw.chomp
      next if line.empty? || line.start_with?('#')

      line.include?(':') ? line.split(':', 2) : [line, line]
    end
  end

  it 'has no malformed entries' do
    aggregate_failures do
      entries.each do |src, dst|
        expect(src).not_to be_empty, "Empty source in .expand entry '#{src}:#{dst}'"
        expect(dst).not_to be_empty, "Empty destination in .expand entry '#{src}:#{dst}'"
      end
    end
  end

  it 'has all source paths existing at repo root' do
    aggregate_failures do
      entries.map(&:first).each do |src|
        full_path = repo_root.join(src)
        expect(full_path.exist?).to be(true), ".expand source '#{src}' does not exist (looked at #{full_path})"
      end
    end
  end

  it 'has no duplicate destinations' do
    duplicates = entries.map { |_src, dst| dst }.tally.select { |_, count| count > 1 }.keys

    expect(duplicates).to be_empty, "Duplicate destinations in .expand: #{duplicates.join(', ')}"
  end

  it 'declares every symlink escaping the app root' do
    app_root = Rails.root
    dev_only = %w[AGENTS.md commons].map { |p| app_root.join(p).to_s }
    declared = entries.to_set { |_src, dst| app_root.join(dst).cleanpath.to_s }

    undeclared = Dir.glob(app_root.join('**/*'), File::FNM_DOTMATCH).filter_map do |path|
      next unless File.symlink?(path)
      next if dev_only.include?(path)

      lexical_target = Pathname.new(File.expand_path(File.readlink(path), File.dirname(path))).cleanpath.to_s
      next if lexical_target == app_root.to_s || lexical_target.start_with?("#{app_root}/")
      next if declared.include?(Pathname.new(path).cleanpath.to_s)

      Pathname.new(path).relative_path_from(app_root).to_s
    end

    expect(undeclared).to be_empty,
      "Symlinks escaping the app root must be declared in .expand: #{undeclared.join(', ')}"
  end
end
