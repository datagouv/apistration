RSpec.describe INSEEPasswordRotationJob do
  subject(:rotate) { described_class.perform_now }

  let(:rotation) { instance_double(INSEE::PasswordRotation, held_back?: false, rotate!: :already_current) }
  let(:bypass_password) { 'ByPass-Password1' }

  before do
    Timecop.freeze(Date.new(2027, 1, 15))

    allow(Rails.env).to receive(:production?).and_return(true)
    ENV['FRONTAL'] = 'true'

    allow(INSEE::PasswordRotation).to receive(:new).and_return(rotation)
    allow(MonitoringService.instance).to receive(:track)
  end

  after do
    Timecop.return

    ENV['FRONTAL'] = 'true'

    AdminApientreprise.credentials.delete(INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY)
  end

  describe 'guards' do
    it 'does nothing outside of the frontal machine' do
      ENV['FRONTAL'] = 'false'

      rotate

      expect(rotation).not_to have_received(:rotate!)
    end

    it 'does nothing outside of production' do
      allow(Rails.env).to receive(:production?).and_return(false)

      rotate

      expect(rotation).not_to have_received(:rotate!)
    end

    it 'does nothing while the bypass password is in use' do
      AdminApientreprise.credentials[INSEE::PasswordDerivation::BYPASS_CREDENTIAL_KEY] = bypass_password

      rotate

      expect(rotation).not_to have_received(:rotate!)
    end

    it 'does nothing before the derivation window opens' do
      Timecop.freeze(Date.new(2026, 9, 7))

      rotate

      expect(rotation).not_to have_received(:rotate!)
    end

    it 'does nothing while an authentication failure is held' do
      allow(rotation).to receive(:held_back?).and_return(true)

      rotate

      expect(rotation).not_to have_received(:rotate!)
    end
  end

  context 'when the rotation renews the password' do
    before { allow(rotation).to receive(:rotate!).and_return(:renewed) }

    it 'reports it' do
      rotate

      expect(MonitoringService.instance).to have_received(:track).with('INSEE password rotated', level: :info, context: {})
    end
  end

  context 'when INSEE already holds the current password' do
    it 'stays silent' do
      rotate

      expect(MonitoringService.instance).not_to have_received(:track)
    end
  end

  context 'when the rotation cannot conclude' do
    before do
      allow(rotation).to receive(:rotate!).and_raise(
        INSEE::PasswordRotation::UnavailableError, 'INSEE OAuth is unavailable'
      )
    end

    it 'reports the skip instead of failing the job' do
      rotate

      expect(MonitoringService.instance).to have_received(:track).with(
        'INSEE password rotation skipped',
        level: :warning,
        context: { exception_message: 'INSEE OAuth is unavailable' }
      )
    end
  end
end
