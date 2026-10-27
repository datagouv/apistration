require 'rails_helper'

RSpec.describe Admin::Tokens::Create, type: :organizer do
  subject { described_class.call(authorization_request:, exp_date: nil, admin:, namespace: 'entreprise') }

  let(:admin) { create(:user, :admin) }
  let(:authorization_request) { create(:authorization_request, :with_demandeur, api: 'entreprise') }

  it { is_expected.to be_a_success }

  it 'creates a token' do
    expect { subject }.to change(Token, :count).by(1)
  end

  it 'emits a token creation by the admin' do
    expect { subject }.to emit_security_event('token.api_token.created').with(
      actor: { email: admin.email, role: 'admin' },
      target: { type: 'token', id: kind_of(String) },
      details: hash_including(source: 'admin', datapass_id: authorization_request.external_id)
    )
  end

  it 'records an admin activity' do
    expect { subject }.to change(AdminActivity, :count).by(1)

    expect(AdminActivity.last).to have_attributes(
      name: 'token_created',
      admin:,
      namespace: 'entreprise',
      entity: Token.last
    )
  end

  it 'stores the token details in the activity' do
    subject

    expect(AdminActivity.last.after_attributes).to eq(
      'exp' => Token.last.exp,
      'scopes' => Token.last.scopes
    )
  end
end
