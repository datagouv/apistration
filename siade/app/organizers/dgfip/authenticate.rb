class DGFIP::Authenticate < ApplicationOrganizer
  organize DGFIP::Authenticate::MakeRequest,
    DGFIP::Authenticate::ValidateResponse

  after do
    context.cookie = context.response['set-cookie'] unless staging?
  end
end
