require 'openssl'

class INSEE::PasswordDerivation
  DERIVATION_START = '2026-09'.freeze
  BIMESTER_MONTHS = [1, 3, 5, 7, 9, 11].freeze
  PASSWORD_LENGTH = 16
  CHAR_GUARANTEES = {
    /[A-Z]/ => 'A',
    /[a-z]/ => 'a',
    /[0-9]/ => '0',
    /[^a-zA-Z0-9]/ => '#'
  }.freeze

  def self.current_password
    password_for(current_period)
  end

  def self.previous_password
    password_for(previous_period)
  end

  def self.current_period
    period_for(Time.zone.today)
  end

  def self.previous_period
    date = Time.zone.today
    month = BIMESTER_MONTHS.rfind { |m| m <= date.month }

    if month == BIMESTER_MONTHS.first
      format('%<year>d-%<month>02d', year: date.year - 1, month: BIMESTER_MONTHS.last)
    else
      idx = BIMESTER_MONTHS.index(month)
      format('%<year>d-%<month>02d', year: date.year, month: BIMESTER_MONTHS[idx - 1])
    end
  end

  def self.password_for(period)
    return Siade.credentials[:insee_apim_password] if period < DERIVATION_START

    derive(period)
  end

  def self.derive(period)
    hmac = OpenSSL::HMAC.digest('SHA256', secret, period)
    format_password(hmac)
  end

  def self.period_for(date)
    month = BIMESTER_MONTHS.rfind { |m| m <= date.month }
    format('%<year>d-%<month>02d', year: date.year, month:)
  end

  def self.format_password(hmac_bytes)
    chars = Base64.urlsafe_encode64(hmac_bytes, padding: false)[0, PASSWORD_LENGTH].chars

    CHAR_GUARANTEES.each_with_index do |(pattern, fallback), idx|
      chars[idx] = fallback unless chars.any? { |c| c.match?(pattern) }
    end

    chars.join
  end

  def self.secret
    Siade.credentials[:insee_apim_password_derivation_key]
  end

  private_class_method :password_for, :derive, :period_for, :format_password, :secret
end
