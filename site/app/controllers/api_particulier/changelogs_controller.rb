# frozen_string_literal: true

class APIParticulier::ChangelogsController < APIParticulierController
  def index
    @entries_by_year = ChangelogEntry.grouped_by_year_for(:api_particulier)

    render 'shared/changelogs/index'
  end
end
