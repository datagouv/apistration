require 'date'

if ARGV.count.zero?
  STDERR.print "Usage: #{$PROGRAM_NAME} environment [token_uuid]"
  exit 1
end

env = ARGV[0]

ENV['RAILS_ENV'] = env

require File.expand_path('../config/application', __dir__)

require_relative '../app/lib/jwt_user'

uid = ARGV[1] || JwtUser.debugger_id

if uid !~ /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/
  STDERR.print "Invalid token UUID: #{uid}\n"
  exit 2
end

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
  uid: uid,
  jti: uid,
  scopes: scopes,
  sub: "#{env} development",
  iat: Time.now.to_i,
  version: '1.0',
  exp: exp,
  mcp: true
}.compact

token = JWT.encode(token_payload, jwt_hash_secret, jwt_hash_algo)

print token
