RSpec.describe Token::Reveal, type: :organizer do
  let(:token) { create(:token) }

  it 'emits no reveal while an admin impersonates the demandeur, the page hiding the token' do
    expect { described_class.call(token:, impersonating: true) }.not_to emit_security_event('token.api_token.revealed')
  end
end
