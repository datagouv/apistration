module Transliterator
  extend ActiveSupport::Concern

  private

  def transliterate(value)
    return value if value.nil?

    ActiveSupport::Inflector.transliterate(value)
  end
end
