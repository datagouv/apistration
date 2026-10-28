# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/mailers/token_mailer'

RSpec.describe APIEntreprise::TokenMailer, type: :feature do
  it_behaves_like 'a token mailer', :entreprise, :authorization_request_path
end
