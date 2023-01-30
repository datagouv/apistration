RSpec.describe './bin/generate_payload_readme.rb' do
  it 'does not raise error' do
    expect { load('./bin/generate_payload_readme.rb') }.not_to raise_error
  end

end
