class INPI::Authenticate::ValidateResponse < ValidateResponse
  def call
    context.fail! unless cookie
  end

  private

  def cookie
    context.response['set-cookie']
      &.match(/(JSESSIONID=.+); Path=.+/)
      &.captures
      &.first
  end
end
