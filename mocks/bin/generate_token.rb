require 'byebug'
require 'date'
require 'yaml'
require 'jwt'
require 'securerandom'

jwt_hash_secret = 'ea0a029b813836b17cb574fa53d7a626302389f2fa16a7b0596e47c317ebdacf0578e494b691537663044ed94751153a01ff2f518484f4323baba4ae466bb4b2'
jwt_hash_algo = 'HS256'

root_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
all_scopes = YAML.load_file(File.join(root_path, 'data', 'siade_authorizations.yml'), aliases: true)['shared'].values.flatten.uniq

scopes = ARGV.count == 0 ? all_scopes : ARGV

token_payload = {
  uid: SecureRandom.uuid,
  jti: "00000000-0000-0000-0000-000000000000",
  scopes: scopes,
  sub: "staging",
  iat: Time.now.to_i,
  version: '1.0',
  exp: DateTime.now.next_year(10).to_time.to_i
}

token = JWT.encode(token_payload, jwt_hash_secret, jwt_hash_algo)

print token
