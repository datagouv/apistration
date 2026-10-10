require 'rails_helper'

RSpec.describe SecurityEvent do
  let(:user) { create(:user) }

  after { Rails.event.clear_context }

  describe '.emit' do
    subject(:emit) do
      described_class.emit('auth.session.closed', target: { type: 'user', id: user.id }, details: { reason: 'logout' })
    end

    it 'emits the event with its target and details' do
      expect { emit }.to emit_security_event('auth.session.closed').with(
        target: { type: 'user', id: user.id },
        details: { reason: 'logout' }
      )
    end

    it 'uses an anonymous actor when no actor context is set' do
      expect { emit }.to emit_security_event('auth.session.closed').with(
        actor: { email: nil, role: 'anonymous' }
      )
    end

    it 'uses the actor set for the request' do
      described_class.set_request_context(user:, true_user: user)

      expect { emit }.to emit_security_event('auth.session.closed').with(
        actor: { email: user.email, role: 'user' },
        details: { reason: 'logout' }
      )
    end

    it 'adds the impersonating admin email when the action is impersonated' do
      admin = create(:user, :admin)
      described_class.set_request_context(user:, true_user: admin)

      expect { emit }.to emit_security_event('auth.session.closed').with(
        details: { reason: 'logout', impersonated_by: admin.email }
      )
    end

    it 'prefers an explicit actor over the request one' do
      described_class.set_request_context(user:, true_user: user)

      expect {
        described_class.emit('auth.login.attempted', actor: { email: 'other@example.com', role: 'anonymous' }, target: { type: 'user', id: nil })
      }.to emit_security_event('auth.login.attempted').with(
        actor: { email: 'other@example.com', role: 'anonymous' }
      )
    end

    it 'omits details when they are all nil' do
      payloads = SecurityEventRecorder.new.record do
        described_class.emit('auth.login.attempted', target: { type: 'user', id: nil }, details: { idp: nil })
      end

      expect(payloads.sole).not_to have_key(:details)
    end

    it 'waits for the transaction to be committed' do
      recorder = SecurityEventRecorder.new
      emitted_inside_transaction = nil

      recorder.record do
        ActiveRecord::Base.transaction do
          emit
          emitted_inside_transaction = recorder.events.dup
        end
      end

      expect(emitted_inside_transaction).to be_empty
      expect(recorder.events.sole).to include(event: 'auth.session.closed')
    end

    it 'is never emitted when the transaction is rolled back' do
      expect {
        ActiveRecord::Base.transaction do
          emit
          raise ActiveRecord::Rollback
        end
      }.not_to emit_security_event('auth.session.closed')
    end

    it 'raises on an undeclared event' do
      expect {
        described_class.emit('auth.unknown.happened', target: { type: 'user', id: 1 })
      }.to raise_error(ActiveSupport::ErrorReporter::UnexpectedError, /auth.unknown.happened/)
    end

    it 'raises on an undeclared detail' do
      expect {
        described_class.emit('auth.session.closed', target: { type: 'user', id: 1 }, details: { password: 'secret' })
      }.to raise_error(ActiveSupport::ErrorReporter::UnexpectedError, /password/)
    end

    context 'when unexpected errors are only reported' do
      before { allow(Rails.error).to receive(:unexpected) }

      it 'still emits the event with the catalog error' do
        expect {
          described_class.emit('auth.session.closed', target: { type: 'user', id: 1 }, details: { password: 'secret' })
        }.to emit_security_event('auth.session.closed').with(
          details: hash_including(catalog_error: a_string_including('password'))
        )
      end
    end
  end

  describe '.actor_for' do
    it 'tags admins' do
      expect(described_class.actor_for(create(:user, :admin))).to include(role: 'admin')
    end

    it 'tags editor members' do
      expect(described_class.actor_for(create(:user, :editor))).to include(role: 'editor')
    end

    it 'tags other users as user' do
      expect(described_class.actor_for(user)).to eq(email: user.email, role: 'user')
    end

    it 'falls back to anonymous without user' do
      expect(described_class.actor_for(nil)).to eq(email: nil, role: 'anonymous')
    end
  end
end
