# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/features/changelogs'

RSpec.describe 'Changelogs', app: :api_particulier do
  let(:api) { :api_particulier }

  it_behaves_like 'a changelogs feature'
end
