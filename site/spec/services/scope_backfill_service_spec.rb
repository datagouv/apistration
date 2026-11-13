require 'rails_helper'

RSpec.describe ScopeBackfillService do
  subject(:service) { described_class.new(added_scope: 'new_scope', when_any_of: %w[trigger_a trigger_b]) }

  it 'adds the scope to tokens and authorization requests holding a trigger scope, once' do
    triggered = create(:token, scopes: %w[trigger_b other])
    triggered.authorization_request.update!(scopes: triggered.scopes)
    untouched = create(:token, scopes: %w[other])
    already_granted = create(:token, scopes: %w[trigger_a new_scope])

    service.up

    expect(triggered.reload.scopes).to eq(%w[trigger_b other new_scope])
    expect(triggered.authorization_request.reload.scopes).to eq(%w[trigger_b other new_scope])
    expect(untouched.reload.scopes).to eq(%w[other])
    expect(already_granted.reload.scopes).to eq(%w[trigger_a new_scope])
  end

  it 'removes the scope on down' do
    token = create(:token, scopes: %w[trigger_a new_scope])
    token.authorization_request.update!(scopes: token.scopes)

    service.down

    expect(token.reload.scopes).to eq(%w[trigger_a])
    expect(token.authorization_request.reload.scopes).to eq(%w[trigger_a])
  end
end
