RSpec.describe AllowedIpsValidator do
  subject(:model) { dummy_class.new(allowed_ips:) }

  let(:dummy_class) do
    Class.new do
      include ActiveModel::Model

      attr_accessor :allowed_ips

      validates :allowed_ips, allowed_ips: true

      def self.name
        'DummyAllowedIps'
      end
    end
  end

  context 'when the list is empty' do
    let(:allowed_ips) { [] }

    it { is_expected.to be_valid }
  end

  context 'when the list is nil' do
    let(:allowed_ips) { nil }

    it { is_expected.to be_valid }
  end

  context 'with valid exact IPs and CIDR ranges' do
    let(:allowed_ips) { ['203.0.113.10', '203.0.113.0/24', '2001:db8::1'] }

    it { is_expected.to be_valid }
  end

  context 'with IPAddr instances' do
    let(:allowed_ips) { [IPAddr.new('203.0.113.10')] }

    it { is_expected.to be_valid }
  end

  context 'with a malformed entry' do
    let(:allowed_ips) { ['999.999.1.1'] }

    it { is_expected.not_to be_valid }
  end

  context 'with a non-IP string' do
    let(:allowed_ips) { ['wat'] }

    it { is_expected.not_to be_valid }
  end

  context 'with an IPv4 range wider than /24' do
    let(:allowed_ips) { ['203.0.0.0/16'] }

    it { is_expected.not_to be_valid }
  end

  context 'with 0.0.0.0/0' do
    let(:allowed_ips) { ['0.0.0.0/0'] }

    it { is_expected.not_to be_valid }
  end

  context 'with ::/0' do
    let(:allowed_ips) { ['::/0'] }

    it { is_expected.not_to be_valid }
  end

  context 'with private or reserved ranges' do
    %w[10.1.2.3 172.16.5.4 192.168.1.0/24 127.0.0.1 169.254.10.5 ::1 fc00::1].each do |entry|
      context "with #{entry}" do
        let(:allowed_ips) { [entry] }

        it { is_expected.not_to be_valid }
      end
    end
  end

  context 'with 10 entries' do
    let(:allowed_ips) { (1..10).map { |i| "203.0.113.#{i}" } }

    it { is_expected.to be_valid }
  end

  context 'with more than 10 entries' do
    let(:allowed_ips) { (1..11).map { |i| "203.0.113.#{i}" } }

    it { is_expected.not_to be_valid }
  end
end
