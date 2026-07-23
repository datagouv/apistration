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

  describe '/developpeurs editor delegation section' do
    before { visit developers_path }

    it 'documents the editor delegation integration (concepts, listing, consumption, errors)' do
      expect(page).to have_css('#integration-editeur')
      expect(page).to have_css('#editeur-concepts')
      expect(page).to have_css('#editeur-espace')
      expect(page).to have_css('#editeur-lister-delegations')
      expect(page).to have_css('#editeur-appeler-pour-un-client')
      expect(page).to have_css('#editeur-contrat-erreurs')

      expect(page).to have_text('recipient')
      expect(page).to have_text('delegation_id')
      expect(page).to have_text('/editeur/api/v1/delegations')
    end
  end
end
