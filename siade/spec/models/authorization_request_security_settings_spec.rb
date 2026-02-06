RSpec.describe AuthorizationRequestSecuritySettings do
  describe '#ip_allowed?' do
    let(:authorization_request) { AuthorizationRequest.create!(siret: '12345678901234') }
    let(:security_settings) do
      described_class.create!(
        authorization_request:,
        allowed_ips:
      )
    end

    context 'with allowed_ips configured as CIDR range' do
      let(:allowed_ips) { ['192.168.1.0/24', '10.0.0.1'] }

      it 'allows IP in CIDR range' do
        expect(security_settings.ip_allowed?('192.168.1.50')).to be true
      end

      it 'allows exact IP match' do
        expect(security_settings.ip_allowed?('10.0.0.1')).to be true
      end

      it 'denies IP not in whitelist' do
        expect(security_settings.ip_allowed?('8.8.8.8')).to be false
      end

      it 'denies IP outside CIDR range' do
        expect(security_settings.ip_allowed?('192.168.2.1')).to be false
      end
    end

    context 'with empty allowed_ips' do
      let(:allowed_ips) { [] }

      it 'allows any IP' do
        expect(security_settings.ip_allowed?('8.8.8.8')).to be true
      end
    end

    context 'with invalid IP in allowed_ips' do
      let(:allowed_ips) { ['invalid_ip', '192.168.1.0/24'] }

      it 'ignores invalid entry and checks valid ones' do
        expect(security_settings.ip_allowed?('192.168.1.50')).to be true
      end

      it 'denies IP not matching valid entries' do
        expect(security_settings.ip_allowed?('8.8.8.8')).to be false
      end
    end

    context 'with invalid request IP' do
      let(:allowed_ips) { ['192.168.1.0/24'] }

      it 'returns false for invalid request IP' do
        expect(security_settings.ip_allowed?('not_an_ip')).to be false
      end
    end
  end
end
