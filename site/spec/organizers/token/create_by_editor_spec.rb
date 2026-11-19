RSpec.describe Token::CreateByEditor do
  subject(:generate_token) { described_class.call(authorization_request:, editor:, user: editor_user) }

  let(:editor) { create(:editor, copy_token: true, form_uids: ['logiciel-mairie']) }
  let(:editor_user) { create(:user, editor:) }
  let(:authorization_request) do
    create(:authorization_request, :with_demandeur, demarche: 'logiciel-mairie', status: 'validated', validated_at: 1.day.ago)
  end

  it 'emits the creation of the token by the editor' do
    expect { generate_token }.to emit_security_event('token.api_token.created').with(
      target: { type: 'token', id: kind_of(String) },
      details: {
        source: 'editor',
        datapass_id: authorization_request.external_id,
        expires_at: Time.zone.at(18.months.from_now.to_i),
        scopes: authorization_request.scopes
      }
    )
  end

  it 'emits no creation when the editor may not generate a token' do
    editor.update!(copy_token: false)

    expect { generate_token }.not_to emit_security_event('token.api_token.created')
  end
end
