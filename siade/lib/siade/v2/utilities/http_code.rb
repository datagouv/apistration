class SIADE::V2::Utilities::HTTP_code
  def self.generate_best_http_code(http_codes)
    best_code = 500
    http_codes.sort!

    http_codes.each do |code|
      case code

      when 404
        best_code = self.best_code_404(best_code)

      when 400..599
        best_code = self.best_code_400_500(best_code, code)

      when 200..206
        best_code = code

      else
        Rails.logger.error "unhandled http code #{code} in generate_best_http_code (unusable error message here...)"
        best_code = 500
      end
    end

    best_code
  end

  private

  def self.best_code_404(best_code)
    case best_code
    when 200..206
      206
    else
      404
    end
  end

  def self.best_code_400_500(best_code, current_code)
    case best_code
    when 200..206
      206
    when 404
      404
    else
      current_code
    end
  end
end
