require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'colorize'

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
set :repository, 'git@gitlab.com:etalab/api-entreprise/siade.git'

branch = ENV['branch'] || begin
                            case ENV['to']
                            when 'production'
                              'master'
                            when 'staging'
                              'staging'
                            when 'development', 'sandbox'
                              'develop'
                            end
                          end

set :branch, branch
ensure!(:branch)

print "Deploy to #{ENV['to']} environment\n".green
print "Deploying branch #{branch} environment\n".yellow

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
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
])

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
  # Production database has to be setup !
end

desc 'Deploys the current version to the server.'
task :deploy do
  deploy do
    comment %{DEPLOYING ON NEW INFRA}.yellow
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    set :bundle_options, fetch(:bundle_options) + ' --clean'
    invoke :'bundle:install'
    invoke :generate_swagger_file

    on :launch do
      invoke :'passenger'
    end
  end
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

task :generate_swagger_file do
  command %{./bin/generate_swagger.sh}
end
