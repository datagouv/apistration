class ProlongTokenWizard::Finish < ApplicationInteractor
  def call
    return if wizard.after?(:finished)

    wizard.finish!
    return unless wizard.prolonged?

    context.prolonged_token = wizard.token
    context.token_prolonged = wizard.token.saved_change_to_exp?
  end

  private

  def wizard
    context.prolong_token_wizard
  end
end
