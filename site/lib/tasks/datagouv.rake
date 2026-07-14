namespace :datagouv do
  desc 'Sync fiche uids to data.gouv.fr. Reads a comma-separated list from the SYNC_UIDS env var ' \
       '(the mechanism used by the GitHub Actions workflow, which avoids a shell/CLI comma-splitting ' \
       'limitation in Rake bracket arguments). Falls back to the bracket argument for a single uid ' \
       "when run manually, e.g. `rails 'datagouv:sync[some/uid]'` -- do NOT rely on the bracket " \
       'argument for more than one uid: Rake splits `task[a,b,c]` into separate positional arguments ' \
       'before the task runs, so only the first would ever bind.'
  task :sync, [:uids] => :environment do |_t, args|
    uids = ENV.fetch('SYNC_UIDS', args[:uids].to_s).split(',').map(&:strip)
    endpoints = (APIEntreprise::Endpoint.all + APIParticulier::Endpoint.all).select { |endpoint| uids.include?(endpoint.uid) }
    exit(1) unless Datagouv::SyncRunner.new(endpoints).call
  end

  desc 'Sync every endpoint fiche to data.gouv.fr'
  task sync_all: :environment do
    endpoints = APIEntreprise::Endpoint.all + APIParticulier::Endpoint.all
    exit(1) unless Datagouv::SyncRunner.new(endpoints).call
  end
end
