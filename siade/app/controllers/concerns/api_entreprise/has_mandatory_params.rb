module APIEntreprise::HasMandatoryParams
  extend ActiveSupport::Concern

  class NotAcceptable < StandardError
  end

  included do
    before_action :context_is_filled!
    rescue_from NotAcceptable, with: :not_acceptable
  end

  def not_acceptable
    render json:   ErrorsSerializer.new(errors).as_json,
      status: :unprocessable_content
  end

  private

  def context_is_filled!
    raise NotAcceptable unless context_is_filled?
  end

  def context_is_filled?
    mandatory_field_list.each do |field|
      errors << MissingMandatoryParamError.new(field) if params[field].blank?
    end

    errors.empty?
  end

  def mandatory_field_list
    %i[
      context
      recipient
      object
    ]
  end

  def errors
    @errors ||= []
  end
end
