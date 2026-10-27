class Token::FinishProlongWizard < ApplicationOrganizer
  before do
    context.token_prolongation_source = 'applicant'
  end

  organize ProlongTokenWizard::Finish,
    Token::TrackProlongation
end
