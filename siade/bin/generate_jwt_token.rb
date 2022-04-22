extra_roles = [
  'exercices',
  'attestations_fiscales',
  'liasse_fiscale',
  'entreprises_artisanales',
]

if ARGV.count.zero?
  STDERR.print "Usage: #{$PROGRAM_NAME} environment"
  exit 1
end

env = ARGV[0]

ENV['RAILS_ENV'] = env

require File.expand_path('../../config/application', __FILE__)

credentials = Rails.application.credentials.config[env.to_sym]

if credentials.nil?
  STDERR.print "#{env} is not a valid environment"
  exit 2
end

jwt_hash_secret = credentials[:jwt_hash_secret]
jwt_hash_algo = credentials[:jwt_hash_algo]

raw_grep_roles = `grep --no-filename -R "authorize :" app/controllers/`

roles = raw_grep_roles.split.reject do |str|
  str == 'authorize'
end.map do |role_symbol|
  role_symbol[1..-1]
end.concat(extra_roles).uniq

token_payload = {
  uid: SecureRandom.uuid,
  jti: "00000000-0000-0000-0000-000000000000",
  roles: roles,
  sub: "#{env} development",
  iat: Time.now.to_i,
  version: '1.0',
  exp: env == 'test' ? nil : 1.month.from_now.to_i
}.compact

token = JWT.encode(token_payload, jwt_hash_secret, jwt_hash_algo)

print token
