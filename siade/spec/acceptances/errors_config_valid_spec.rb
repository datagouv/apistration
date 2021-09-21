RSpec.describe 'Errors config file', type: :acceptance do
  let(:errors_config_file) { Rails.root.join('config/errors.yml') }

  it 'is a valid YAML' do
    expect {
      YAML.load_file(errors_config_file)
    }.not_to raise_error
  end

  it 'is has at least a code or subcode properly formated' do
    YAML.load_file(errors_config_file).each do |error_entry|
      expect(error_entry).to have_key('code').or have_key('subcode')

      if error_entry['code']
        expect(error_entry['code']).to match(/^\d{5}$/)
      else
        expect(error_entry['subcode']).to match(/^\d{3}$/)
      end
    end
  end

  it 'has no duplicate code or subcode' do
    error_entries = YAML.load_file(errors_config_file)

    code_or_subcodes = error_entries.map do |error_entry|
      error_entry['code'] ||
        error_entry['subcode']
    end

    expect(code_or_subcodes.uniq.count).to eq(error_entries.count), "has duplicate code or subcode: #{code_or_subcodes.detect { |code_or_subcode| code_or_subcodes.count(code_or_subcode) > 1 }}"
  end
end
