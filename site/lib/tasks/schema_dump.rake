Rake::Task['db:schema:dump'].enhance do
  next unless Rails.env.local?

  schema_path = Rails.root.join('db/schema.rb')
  dumped_view_name = "admin_apientreprise_#{Rails.env}_access_logs_consumption_summary"
  env_agnostic_view_name = 'admin_apientreprise_#{Rails.env}_access_logs_consumption_summary' # rubocop:disable Lint/InterpolationCheck

  schema_path.write(schema_path.read.sub(%("#{dumped_view_name}"), %("#{env_agnostic_view_name}")))
end
