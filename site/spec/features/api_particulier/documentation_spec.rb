# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/features/documentation'

RSpec.describe 'Documentation pages', app: :api_particulier do
  it_behaves_like 'a documentation feature'

  describe '/developpeurs scopes section' do
    before { visit developers_path }

    it 'explains the scope mechanism and how to read a fiche' do
      expect(page).to have_css('#scopes-et-perimetres')
      expect(page).to have_css('#pourquoi-des-scopes')
      expect(page).to have_css('#savoir-quels-champs-necessitent-un-scope')
    end
  end
end
