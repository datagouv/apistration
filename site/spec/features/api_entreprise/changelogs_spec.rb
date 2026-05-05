# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/features/changelogs'

RSpec.describe 'Changelogs', app: :api_entreprise do
  let(:api) { :api_entreprise }

  it_behaves_like 'a changelogs feature'
end
