module HasMandatoryParams
  extend ActiveSupport::Concern

  class NotAcceptable < StandardError;
  end

  included do
    before_action :context_is_filled!
    rescue_from NotAcceptable, with: :not_acceptable
  end

  def not_acceptable
    render json:   ErrorsSerializer.new(errors, format: error_format).as_json,
           status: 422
  end

  private

  def context_is_filled!
    raise NotAcceptable unless context_is_filled?
  end

  def context_is_filled?
    mandatory_field_list.each do |field|
      if params[field].nil? || params[field].empty?
        UserAccessSpy.log_not_acceptable
        errors << MissingMandatoryParamError.new(field)
      end
    end

    errors.empty?
  end

  def mandatory_field_list
    [
      :context,
      :recipient,
      :object,
    ]
  end

  def errors
    @errors ||= []
  end
end
