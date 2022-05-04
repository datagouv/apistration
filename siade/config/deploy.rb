require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'colorize'
require 'securerandom'

ENV['domain'] || raise('no domain provided'.red)

ENV['to'] ||= "sandbox"

unless %w[development sandbox staging production].include?(ENV['to'])
  raise("target environment (#{ENV['to']}) not in the list")
end


set :commit, ENV['commit']
set :user, 'deploy'
set :application_name, 'siade'
set :domain, ENV['domain']

set :deploy_to, "/var/www/siade_#{ENV['to']}"
set :rails_env, ENV['to']

set :execution_mode, :system
set :forward_agent, true
set :port, 22
set :repository, 'git@github.com:etalab/siade.git'

branch = ENV['branch'] || begin
                            case ENV['to']
                            when 'production'
                              'master'
                            when 'staging'
                              'master'
                            when 'development', 'sandbox'
                              'develop'
                            end
                          end

set :branch, branch
ensure!(:branch)

def samhain_db_update
  command %{sudo /usr/local/sbin/update-samhain-db.sh "/var/www/siade_#{ENV['to']}"}
end

print "Deploying branch #{branch} to #{ENV['to']} environment\n".green

set :shared_dirs, fetch(:shared_dirs, []).push(*%w[
  log
  bin
  tmp/pids
  tmp/cache
  tmp/sockets
  config/environments
])

set :shared_files, fetch(:shared_files, []).push(*%w[
  config/jwt_blacklist.yml
  config/jwt_whitelist.yml
  config/master.key
  config/initializers/redis.rb
])

namespace :bundle do
  desc 'Sets the Bundler config options.'
  task :config do
    comment %{Setting the Bundler config options (and cleaning default options)}
    set :bundle_options, -> { '' }
    command %{#{fetch(:bundle_bin)} config set --local deployment 'true'}
    command %{#{fetch(:bundle_bin)} config set --local path '#{fetch(:bundle_path)}'}
    command %{#{fetch(:bundle_bin)} config set --local without '#{fetch(:bundle_withouts)}'}
  end
end

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  if ENV['domain'] != 'localhost'
    # Be sure to commit your .ruby-version or .rbenv-version to your repository.
    set :rbenv_path, '/usr/local/rbenv'
    invoke :'rbenv:load'
  end
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  samhain_db_update
  # Production database has to be setup !
end

desc 'Deploys the current version to the server.'
task :deploy do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:config'
    invoke :'bundle:install'
    invoke :'bundle:clean'

    on :launch do
      invoke :'passenger'
    end
  end
  samhain_db_update
end

task :passenger do
  comment %{Attempting to start Passenger app}.green
  command %{
    if (sudo passenger-status | grep siade_#{ENV['to']}) >/dev/null
    then
      passenger-config restart-app /var/www/siade_#{ENV['to']}/current
    else
      echo 'Skipping: no passenger app found (will be automatically loaded)'
    fi
  }
end
