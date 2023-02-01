class INPI::Authenticate < ApplicationOrganizer
  organize INPI::Authenticate::MakeRequest,
    INPI::Authenticate::ValidateResponse

  after do
    context.cookie = cookie unless staging?
  end

  private

  def cookie
    context.response['set-cookie']
      &.match(/(JSESSIONID=.+); Path=.+/)
      &.captures
      &.first
  end
end
