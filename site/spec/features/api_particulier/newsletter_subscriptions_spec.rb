# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/features/newsletter_subscriptions'

RSpec.describe 'Newsletter subscriptions', app: :api_particulier do
  it_behaves_like 'a newsletter subscription feature', list_id: 4, template_id: 7
end
