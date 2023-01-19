require 'date'

if ARGV.count.zero?
  STDERR.print "Usage: #{$PROGRAM_NAME} environment"
  exit 1
end

env = ARGV[0]

config_to_retrieve = env == 'staging' ? 'production' : env
ENV['RAILS_ENV'] = config_to_retrieve

require File.expand_path('../../config/application', __FILE__)

credentials = Rails.application.credentials.config[env.to_sym]

if credentials.nil?
  STDERR.print "#{env} is not a valid environment"
  exit 2
end

jwt_hash_secret = credentials[:jwt_hash_secret]
jwt_hash_algo = credentials[:jwt_hash_algo]

scopes = Rails.application.config_for(:authorizations).values.flatten.uniq

exp = case env
  when 'staging'
    DateTime.now.next_year(10).to_i
  when 'test'
    nil
  else
    DateTime.now.next_month.to_i
  end

token_payload = {
  uid: SecureRandom.uuid,
  jti: "00000000-0000-0000-0000-000000000000",
  scopes: scopes,
  sub: "#{env} development",
  iat: Time.now.to_i,
  version: '1.0',
  exp: exp,
}.compact

token = JWT.encode(token_payload, jwt_hash_secret, jwt_hash_algo)

print token
