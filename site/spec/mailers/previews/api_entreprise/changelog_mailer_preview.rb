class APIEntreprise::ChangelogMailerPreview < ActionMailer::Preview
  def weekly
    APIEntreprise::ChangelogMailer.weekly(subscription.id, entry_attributes)
  end

  private

  def subscription
    ChangelogSubscription.for_scope('api_entreprise').first ||
      ChangelogSubscription.create!(user: User.first, scope: 'api_entreprise')
  end

  def entry_attributes
    entries = ChangelogEntry.for(:api_entreprise).first(3)
    entries = [fallback_entry] if entries.empty?

    entries.map { |entry| { date: entry.date, scope: entry.scope, title: entry.title, description: entry.description } }
  end

  def fallback_entry
    ChangelogEntry.new(
      date: Date.current,
      scope: 'api_entreprise',
      title: 'Exemple de nouveauté',
      description: 'Description **markdown** de la nouveauté.'
    )
  end
end
