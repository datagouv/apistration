# frozen_string_literal: true

class AddJobsFinishedAtToGoodJobBatches < ActiveRecord::Migration[8.1]
  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.column_exists?(:good_job_batches, :jobs_finished_at)
      end
    end

    add_column :good_job_batches, :jobs_finished_at, :datetime
  end
end
