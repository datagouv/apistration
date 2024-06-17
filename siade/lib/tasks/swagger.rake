namespace :swagger do
  desc 'Update OpenAPI definitions'
  task generate: :environment do
    sh Rails.root.join('bin/generate_swagger.sh').to_s
  end
end
