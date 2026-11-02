class TVAIntracommunautaire
  ALPHANUMERIC_KEY_ALPHABET = '0123456789ABCDEFGHJKLMNPQRSTUVWXYZ'.freeze

  attr_reader :siren

  def initialize(siren)
    @siren = siren
  end

  def perform
    "FR#{cle}#{siren}"
  end

  def cle
    cle = ((((siren.to_i % 97) * 3) + 12) % 97).to_s
    cle.rjust(2, '0')
  end

  def candidates
    [perform] + alphanumeric_cles.map { |alphanumeric_cle| "FR#{alphanumeric_cle}#{siren}" }
  end

  private

  def alphanumeric_cles
    ALPHANUMERIC_KEY_ALPHABET.chars.product(ALPHANUMERIC_KEY_ALPHABET.chars)
      .map(&:join)
      .grep_v(/\A\d{2}\z/)
      .select { |cle| valid_alphanumeric_cle?(cle) }
  end

  def valid_alphanumeric_cle?(cle)
    check = alphanumeric_check_value(cle)

    (siren.to_i + 1 + (check / 11)) % 11 == check % 11
  end

  def alphanumeric_check_value(cle)
    first_index = ALPHANUMERIC_KEY_ALPHABET.index(cle[0])
    second_index = ALPHANUMERIC_KEY_ALPHABET.index(cle[1])

    if cle[0].match?(/\d/)
      (first_index * 24) + second_index - 10
    else
      (first_index * 34) + second_index - 100
    end
  end
end
