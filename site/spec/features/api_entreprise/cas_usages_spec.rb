# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/features/cas_usages'

RSpec.describe 'Cas usages pages', app: :api_entreprise do
  it_behaves_like 'a cas usages feature', APIEntreprise

  it 'displays Socle de base endpoint table' do
    visit cas_usage_path(uid: 'socle_de_base')

    expect(page).to have_table
    expect(page).to have_css("a[href='#{endpoint_path(uid: 'insee/unites_legales')}']")
  end
end
