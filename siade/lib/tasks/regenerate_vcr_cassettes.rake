namespace :vcr do
  desc 'Regenerate VCR cassettes in Sanbox environment'

  task regen_all: :environment do
    clean_cassettes(all: true)

    run_rspec

    end_message
  end

  task regen: :environment do
    clean_cassettes

    run_rspec

    end_message
  end

  def clean_cassettes(all: false)
    puts 'deleting old VCR cassettes...'.green
    puts 'WARNING: ignoring non_regenerable cassettes folder /!\\'.light_red unless all
    old_cassettes = Rake::FileList.new('spec/fixtures/cassettes/**/*.yml') do |fl|
      fl.exclude('spec/fixtures/cassettes/non_regenerable/*.yml') unless all
    end

    File.delete(*old_cassettes)
  end

  def run_rspec
    puts 'Running Rspec'.green
    sh 'regenerate_cassettes=true bundle exec spring rspec'
  end

  def end_message
    puts '>>Done<<'.green
    puts '============================================'
    puts '>> You should check for errors before commit'
    puts '============================================'
  end
end
