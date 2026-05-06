# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/features/changelog_subscriptions'

RSpec.describe 'Changelog subscriptions', app: :api_particulier do
  it_behaves_like 'a changelog subscription feature', :api_particulier
end
