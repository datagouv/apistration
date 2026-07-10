require 'jwt'

RSpec.describe 'Staging token' do
  describe 'default' do
    let(:payload) do
      token = File.read(File.join(root_path, 'tokens', 'default')).strip

      JWT.decode(token, nil, false).first
    end

    let(:all_scopes) do
      YAML.load_file(File.join(root_path, 'commons', 'data', 'authorizations.yml'), aliases: true)['shared'].values.flatten.uniq
    end

    it 'has all the scopes defined in authorizations.yml' do
      expect(payload['scopes'].sort).to eq(all_scopes.sort)
    end
  end
end
