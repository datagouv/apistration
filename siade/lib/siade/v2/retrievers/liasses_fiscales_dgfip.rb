class SIADE::V2::Retrievers::LiassesFiscalesDGFIP
  include ActiveModel::Model

  attr_accessor :siren, :annee, :cookie, :user_id, :request_type

  def retrieve
    declaration_request.perform if %i[declaration both].include?(request_type)
    dictionary_request.perform if %i[dictionary both].include?(request_type)
    self
  end

  def success?
    http_code == 200
  end

  def http_code
    case request_type
    when :both
      [declaration_request.http_code, dictionary_request.http_code].max
    when :declaration
      declaration_request.http_code
    when :dictionary
      dictionary_request.http_code
    end
  end

  def errors
    case request_type
    when :both
      declaration_request.errors + dictionary_request.errors
    when :declaration
      declaration_request.errors
    when :dictionary
      dictionary_request.errors
    end
  end

  def response
    case request_type
    when :both
      declaration_response_body.merge(dictionary_response_body)
    when :declaration
      declaration_response_body
    when :dictionary
      dictionary_response_body
    end
  end

  private

  def declaration_response_body
    JSON.parse(declaration_request.response.body)
  end

  def dictionary_response_body
    JSON.parse(dictionary_request.response.body)
  end

  def declaration_request
    @declaration_request ||= SIADE::V2::Requests::LiassesFiscalesDGFIP.new(request_params.merge(request_name: :declaration))
  end

  def dictionary_request
    @dictionary_request ||= SIADE::V2::Requests::LiassesFiscalesDGFIP.new(request_params.merge(request_name: :dictionary))
  end

  def request_params
    { siren: @siren, annee: @annee, cookie: @cookie, user_id: @user_id }
  end
end
