require 'fileutils'

namespace :dev do
  desc 'initialize a bunch of dev env setup tasks'
  task :init do
    puts 'start initialisation'
    Rake::Task['dev:generate_insee_secrets_file'].invoke
    puts 'end initialisation'
  end

  task :generate_insee_secrets_file do
    puts 'creating insee_secrets.yml file'
    file = File.new('config/insee_secrets.yml', 'w+')
    file.write(insee_secrets.unindent)
  end

  def insee_secrets
    <<-YML
      token: not a valid token
      expiration_date: 1000000000000000
      expires_in: 3600
    YML
  end
end
