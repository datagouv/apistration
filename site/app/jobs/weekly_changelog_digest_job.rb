class WeeklyChangelogDigestJob < ApplicationJob
  queue_as :default

  MAILERS = {
    'api_entreprise' => APIEntreprise::ChangelogMailer,
    'api_particulier' => APIParticulier::ChangelogMailer
  }.freeze

  def perform(reference_date: Time.zone.today)
    range = previous_iso_week_range(reference_date)

    MAILERS.each_key do |scope|
      enqueue_for_scope(scope, range)
    end
  end

  private

  def enqueue_for_scope(scope, range)
    entries = entries_for(scope, range)
    return if entries.empty?

    payload = entries.map { |entry| entry_attributes(entry) }

    ChangelogSubscription.active.for_scope(scope).find_each do |subscription|
      MAILERS.fetch(scope).weekly(subscription.id, payload).deliver_later
    end
  end

  def entries_for(scope, range)
    ChangelogEntry.for(scope.to_sym).select { |entry| range.cover?(entry.date) }
  end

  def previous_iso_week_range(reference_date)
    monday_this_week = reference_date.beginning_of_week(:monday)
    monday_previous_week = monday_this_week - 7.days
    sunday_previous_week = monday_this_week - 1.day

    monday_previous_week..sunday_previous_week
  end

  def entry_attributes(entry)
    {
      date: entry.date,
      scope: entry.scope,
      title: entry.title,
      description: entry.description
    }
  end
end
