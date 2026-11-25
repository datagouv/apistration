# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/shared_examples/features/newsletter_subscriptions'

RSpec.describe 'Newsletter subscriptions', app: :api_entreprise do
  it_behaves_like 'a newsletter subscription feature', list_id: 3, template_id: 6
end
