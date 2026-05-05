class APIParticulier::ChangelogMailerPreview < ActionMailer::Preview
  def weekly
    APIParticulier::ChangelogMailer.weekly(subscription.id, entry_attributes)
  end

  private

  def subscription
    ChangelogSubscription.for_scope('api_particulier').first ||
      ChangelogSubscription.create!(user: User.first, scope: 'api_particulier')
  end

  def entry_attributes
    entries = ChangelogEntry.for(:api_particulier).first(3)
    entries = [fallback_entry] if entries.empty?

    entries.map { |entry| { date: entry.date, scope: entry.scope, title: entry.title, description: entry.description } }
  end

  def fallback_entry
    ChangelogEntry.new(
      date: Date.current,
      scope: 'api_particulier',
      title: 'Exemple de nouveauté',
      description: 'Description **markdown** de la nouveauté.'
    )
  end
end
