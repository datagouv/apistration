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
end
