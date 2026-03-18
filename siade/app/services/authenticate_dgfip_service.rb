class AuthenticateDGFIPService
  attr_accessor :user
  attr_reader :cookie, :errors, :http_code, :response, :retriever_authenticate

  def initialize
    @errors = []
  end

  def authenticate!
    retrieve_cookie
    self
  end

  def success?
    @errors.empty?
  end

  private

  def retrieve_cookie
    @retriever_authenticate = SIADE::V2::Requests::AuthenticateDGFIP.new
    retriever_authenticate.perform

    @errors += retriever_authenticate.errors
    @cookie = retriever_authenticate.cookie
    @response = retriever_authenticate.response
    @http_code = retriever_authenticate.response.http_code
  end
end
