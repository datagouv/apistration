# frozen_string_literal: true

class APIEntreprise::ChangelogsController < APIEntrepriseController
  def index
    @entries_by_year = ChangelogEntry.grouped_by_year_for(:api_entreprise)

    render 'shared/changelogs/index'
  end
end
